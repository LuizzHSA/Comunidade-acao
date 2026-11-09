# Comunidade em Ação

Aplicativo Flutter para aproximar pessoas de iniciativas solidárias. Nele, é possível explorar campanhas, consultar o que cada comunidade precisa, registrar doações e acompanhar o impacto das contribuições.

> **Estado do projeto:** o app tem integração com Firebase Authentication e Cloud Firestore, além de dados de demonstração locais. Quando o Firebase não está disponível, alguns fluxos continuam em modo local; alterações feitas nesse modo não são sincronizadas nem permanecem depois que o app é fechado.

## O que o aplicativo oferece

- Feed de campanhas com pesquisa e filtros por categoria.
- Detalhes da causa, metas, itens necessários e informações da organização.
- Fluxo demonstrativo para escolher itens e registrar uma doação, com opção de ponto de coleta ou retirada.
- Histórico de doações, perfil e painel de impacto.
- Cadastro de campanhas de exemplo.
- Interface adaptada para celular e uma experiência de desktop com navegação lateral.

## Pré-requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) instalado e configurado.
- Uma versão do Flutter cujo Dart SDK satisfaça o requisito `^3.13.0`, definido em `pubspec.yaml`.
- Um dispositivo ou emulador disponível. Para executar a versão desktop, configure também a plataforma correspondente no Flutter. A compilação para iOS requer macOS e Xcode.

Confira a instalação com:

```bash
flutter doctor
```

## Executar o projeto

Na pasta do projeto, instale as dependências:

```bash
flutter pub get
```

Em seguida, execute no dispositivo ou plataforma desejada:

```bash
flutter run
```

Para selecionar um destino específico, liste os dispositivos e informe o identificador:

```bash
flutter devices
flutter run -d <identificador>
```

No Windows, por exemplo, se o suporte à plataforma estiver habilitado:

```bash
flutter run -d windows
```

## Testes e análise

Execute os testes automatizados:

```bash
flutter test
```

Verifique problemas estáticos no código:

```bash
flutter analyze
```

## Estrutura do projeto

```text
lib/
  main.dart                 Inicialização do app e escolha do layout
  models/                   Modelos de campanhas, doações e perfil
  state/                    Estado compartilhado e dados de demonstração
  screens/                  Telas para a experiência mobile
  screens_windows/          Telas e navegação para desktop
  theme/                    Temas visuais
  widgets/                  Componentes reutilizados e diálogos
assets/images/              Ícone e imagem da tela de abertura
docs/                       Materiais de produto e referências visuais
test/                       Testes automatizados
```

## Como o app funciona

O estado da interface é gerenciado por `Provider` e `ChangeNotifier`, na classe `AppState`. O app inicializa o Firebase em `main.dart`, usando as opções de `lib/firebase_options.dart`. No Android, também usa `android/app/google-services.json`.

O Firebase Authentication aceita entrada por e-mail e senha. Se uma conta ainda não existir, o fluxo atual tenta criá-la com os dados informados; portanto, use credenciais de teste ao experimentar. O Firestore usa o banco `comunidade-em-acao`, configurado em `firebase.json`, para sincronizar campanhas e doações. As regras e os índices locais estão em `firestore.rules` e `firestore.indexes.json`.

Para configurar o Firebase em outro ambiente:

1. Registre o app Android no projeto Firebase e confirme que o `applicationId` coincide com o pacote cadastrado.
2. Ative o provedor **E-mail/senha** no Firebase Authentication.
3. Crie ou confirme o banco Firestore com o ID `comunidade-em-acao`.
4. Revise e publique as regras e os índices, se necessário:

   ```bash
   firebase deploy --only firestore --project mobile-vini
   ```

O comando publica a configuração no projeto Firebase selecionado; revise as regras antes de executá-lo.

Se o Firebase estiver inacessível, o app pode continuar com dados de demonstração em memória. Nesse caso, login ou alterações locais não comprovam que houve autenticação ou gravação na nuvem. A configuração Firebase do código cobre Android, iOS e Web; Windows, macOS e Linux não têm opções Firebase configuradas.

## Preparar uma versão Android para publicação

O AAB de release precisa de uma chave privada de upload. Gere uma única vez e mantenha uma cópia segura fora do repositório:

```bash
keytool -genkeypair -v -keystore android/app/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Crie `android/key.properties` com as senhas e o caminho do keystore, relativo ao módulo Android (`android/app`):

```properties
storePassword=SUA_SENHA_DO_KEYSTORE
keyPassword=SUA_SENHA_DA_CHAVE
keyAlias=upload
storeFile=upload-keystore.jks
```

`android/key.properties` e `android/app/upload-keystore.jks` são arquivos privados ignorados pelo Git. Não os compartilhe nem os adicione ao repositório. Faça backup seguro do keystore e das senhas: perder a chave pode impedir futuras atualizações do app, exceto nos casos cobertos pelo processo de redefinição de chave do Google Play App Signing.

Com a chave configurada, gere o Android App Bundle:

```bash
flutter clean
flutter pub get
flutter build appbundle
```

O arquivo gerado fica em `build/app/outputs/bundle/release/app-release.aab`. Para publicar na Play Store, configure o Google Play App Signing e envie o AAB pelo Play Console; use uma track de teste antes da publicação. Um bundle pode ser validado localmente com o `bundletool`.

Na experiência mobile, o acesso às telas principais é feito pela navegação inferior: **Início**, **Doações**, **Impacto** e **Perfil**. O botão de adicionar abre o fluxo de criação de campanha.

No desktop, o app apresenta uma navegação lateral com feed, exploração de campanhas, doações, criação de campanhas, impacto e configurações. O layout desktop é usado por padrão em plataformas desktop ou em janelas largas; a interface também pode ser escolhida pelo estado de preferência do app.

O formulário de entrada serve apenas para demonstrar o fluxo: preencher e-mail e senha permite entrar, sem validar credenciais em um serviço. Os botões de login social e os dados de pagamento exibidos não representam integrações reais.

## Tecnologias e dependências principais

- **Flutter / Dart** para as interfaces multiplataforma.
- **Provider** para o estado compartilhado.
- **Firebase Core, Authentication e Cloud Firestore** para inicialização, login e sincronização.
- **Google Fonts** para tipografia.
- **intl** para formatação de valores e datas.

As versões das dependências e o requisito do Dart estão definidos em `pubspec.yaml`.

## Ícones do aplicativo

A configuração do ícone usa `assets/images/icon.png` e está em `flutter_launcher_icons.yaml`. Para gerar os ícones nas plataformas configuradas:

```bash
dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
```
