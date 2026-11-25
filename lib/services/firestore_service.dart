import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/models.dart';

/// Serviço central de dados.
///
/// - Na primeira execução, popula o Firestore com os dados de demonstração
///   (campanhas e a conta demo `ana.paula@exemplo.com.br`).
/// - Expõe streams em tempo real para campanhas e histórico de doações.
/// - Grava doações e campanhas novas no Firestore.
/// - Se o Firestore estiver indisponível (sem internet, regras bloqueando,
///   projeto não configurado), o app continua funcionando com os dados demo
///   em memória �?" nada quebra.
class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  FirebaseFirestore get _db => FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'comunidade-em-acao',
  );

  FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Login por e-mail/senha no Firebase Auth.
  ///
  /// Se a conta demo ainda não existir no projeto, cria o usuário no
  /// primeiro login para que a experiência de demonstração continue igual.
  Future<UserCredential> signIn(String email, String password) {
    return _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .catchError((e) {
          final code = e is FirebaseAuthException ? e.code : '';
          if (code == 'user-not-found' || code == 'invalid-credential') {
            // Conta demo: cria o usuário na primeira tentativa.
            return _auth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            );
          }
          throw e;
        });
  }

  Future<void> signOut() => _auth.signOut();

  /// Login com Google usando o fluxo nativo do Firebase Auth.
  ///
  /// Suportado em Android e iOS. Em plataformas desktop o Firebase
  /// não implementa esse fluxo e o app orienta a usar e-mail e senha.
  Future<UserCredential> signInWithGoogle() {
    final provider = GoogleAuthProvider();
    provider.setCustomParameters({'prompt': 'select_account'});
    return _auth.signInWithProvider(provider);
  }

  /// Popular coleções com dados demo se estiverem vazias.
  Future<void> seedIfEmpty({required List<Campaign> demoCampaigns}) async {
    final campaigns = _db.collection('campaigns');
    final snapshot = await campaigns.limit(1).get();
    if (snapshot.docs.isEmpty) {
      final batch = _db.batch();
      for (final c in demoCampaigns) {
        batch.set(campaigns.doc(c.id), c.toMap());
      }
      await batch.commit();
    }
  }

  /// Stream em tempo real das campanhas.
  Stream<List<Campaign>> campaignsStream() {
    return _db
        .collection('campaigns')
        .snapshots()
        .map(
          (s) => s.docs.map((d) => Campaign.fromMap(d.id, d.data())).toList(),
        );
  }

  /// Histórico de doações do usuário logado em tempo real.
  Stream<List<DonationRecord>> donationsStream(String userId) {
    return _db
        .collection('donations')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (s) =>
              s.docs.map((d) => DonationRecord.fromMap(d.id, d.data())).toList()
                ..sort((a, b) => b.date.compareTo(a.date)),
        );
  }

  /// Registrar uma doação confirmada.
  Future<void> addDonation(DonationRecord record) async {
    await _db.collection('donations').doc(record.id).set(record.toMap());

    // Atualiza progresso da campanha (apoio + progresso simples).
    await _db.collection('campaigns').doc(record.campaignId).update({
      'supportersCount': FieldValue.increment(1),
    });
  }

  /// Criar uma nova campanha.
  Future<void> addCampaign(Campaign campaign) async {
    await _db.collection('campaigns').doc(campaign.id).set(campaign.toMap());
  }

  /// Incrementar a quantidade de um item necessária/recebida numa campanha.
  Future<void> incrementCampaignProgress({
    required String campaignId,
    required String itemIndex,
    required int quantity,
  }) async {
    final doc = _db.collection('campaigns').doc(campaignId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(doc);
      if (!snap.exists) return;
      final data = snap.data()!;
      final items = (data['needItems'] as List?) ?? [];
      if (itemIndex.startsWith('item-') == false) return;
      final idx = int.tryParse(itemIndex.split('-').last);
      if (idx == null || idx >= items.length) return;
      final item = Map<String, dynamic>.from(items[idx] as Map);
      final received = ((item['received'] as num?)?.toInt() ?? 0) + quantity;
      item['received'] = received;
      item['metaRemainingText'] =
          '${((item['maxNeeded'] as num?)?.toInt() ?? 0) - received} ${item['unitDescription'] ?? 'un'}';
      items[idx] = item;
      tx.update(doc, {'needItems': items});
    });
  }
}
