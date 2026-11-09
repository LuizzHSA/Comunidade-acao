// Gera demo_user.json no formato aceito por `firebase auth:import`
// usando SCRYPT (mesmos parâmetros padrão do Firebase: N=2^14, r=8, p=1, dkLen=64).
const crypto = require('crypto');

// Chave de hash fixa (gerada uma vez, passada ao auth:import via --hash-key).
// Em produção real, use a hashKey mostrada no Console (Authentication > Settings).
const HASH_KEY_B64 = 'EqBOURx1DMJpfG/n6NxxA2o9V1dwRGm94j6pjwFRcFo=';

const password = '123456';
const salt = crypto.randomBytes(8); // salt por usuário
const saltSeparator = Buffer.from('Bw==', 'base64'); // separador padrão do Firebase
const rounds = 8; // 2^14 = 16384
const memCost = 14;
const keyLen = 64;

// Firebase: scrypt(senha, salt + separator, N, r, p, dkLen)
const hash = crypto.scryptSync(
  password,
  Buffer.concat([salt, saltSeparator]),
  keyLen,
  { N: 1 << memCost, r: rounds, p: 1, maxmem: 64 * 1024 * 1024 },
);

const hashKey = Buffer.from(HASH_KEY_B64, 'base64');
console.log('hashKey (base64): ' + hashKey.toString('base64'));

const user = {
  localId: 'demo-user-ana-paula',
  email: 'ana.paula@exemplo.com.br',
  emailVerified: true,
  displayName: 'Ana Paula',
  salt: salt.toString('base64'),
  passwordHash: hash.toString('base64'),
};

require('fs').writeFileSync(
  'demo_user.json',
  JSON.stringify({ users: [user] }, null, 2),
);
console.log('OK - demo_user.json gerado');
console.log('Params -> rounds:' + rounds + ' memCost:' + memCost);
