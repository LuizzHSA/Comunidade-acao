# Comunidade em Ação

Aplicativo Flutter para aproximar pessoas de iniciativas solidárias. Nele, é possível explorar campanhas, consultar o que cada comunidade precisa, registrar doações e acompanhar o impacto das contribuições.

> **Estado do projeto:** esta versão é uma demonstração de interface e fluxos. O login, as campanhas e as doações usam dados locais de exemplo; não há servidor, autenticação real nem armazenamento permanente.

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

O estado compartilhado é gerenciado por `Provider` e `ChangeNotifier`, na classe `AppState`. Ao iniciar, o aplicativo carrega campanhas, um perfil e um histórico de exemplo. Alterações feitas durante a execução — como criar uma campanha ou registrar uma doação — ficam em memória e são perdidas ao fechar o app.

Na experiência mobile, o acesso às telas principais é feito pela navegação inferior: **Início**, **Doações**, **Impacto** e **Perfil**. O botão de adicionar abre o fluxo de criação de campanha.

No desktop, o app apresenta uma navegação lateral com feed, exploração de campanhas, doações, criação de campanhas, impacto e configurações. O layout desktop é usado por padrão em plataformas desktop ou em janelas largas; a interface também pode ser escolhida pelo estado de preferência do app.

O formulário de entrada serve apenas para demonstrar o fluxo: preencher e-mail e senha permite entrar, sem validar credenciais em um serviço. Os botões de login social e os dados de pagamento exibidos não representam integrações reais.

## Tecnologias e dependências principais

- **Flutter / Dart** para as interfaces multiplataforma.
- **Provider** para o estado compartilhado.
- **Google Fonts** para tipografia.
- **intl** para formatação de valores e datas.

As versões das dependências e o requisito do Dart estão definidos em `pubspec.yaml`.

## Ícones do aplicativo

A configuração do ícone usa `assets/images/icon.png` e está em `flutter_launcher_icons.yaml`. Para gerar os ícones nas plataformas configuradas:

```bash
dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
```
