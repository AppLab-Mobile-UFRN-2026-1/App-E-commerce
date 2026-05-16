# 🛍️ Loja Online

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)

> 🚧 **Projeto em desenvolvimento** — 2ª Unidade · Programação para Dispositivos Móveis · UFRN 2026.1

Uma aplicação mobile de comércio eletrônico desenvolvida em Flutter, construída de forma incremental ao longo de 4 etapas. O app conta com autenticação de usuário, listagem de produtos via API, carrinho de compras e persistência de dados locais.

---

## 📸 Demonstração

> Em breve.

---

## 🗺️ Etapas do Projeto

O projeto é desenvolvido de forma incremental. Cada etapa adiciona novas funcionalidades sobre o que foi construído anteriormente.

### Etapa 1 — Widgets e Layout
Construção da tela de login utilizando a hierarquia de Widgets do Flutter. A etapa foca exclusivamente nos elementos visuais, sem interação com o usuário.

**O que será implementado:**
* Tela de login com campos de usuário e senha (`TextField`)
* Botão de "Login" (`ElevatedButton`)
* Links de "Esqueceu a senha?" e "Não tem uma conta? Cadastre-se"
* Uso de `StatelessWidget`, `StatefulWidget`, `Container`, `Row`, `Column`, `Padding`, `TextStyle`, `BorderRadius` e demais Widgets de layout e estilo

---

### Etapa 2 — Eventos, Navegação e Passagem de Dados
Adição de interatividade à tela de login e implementação da navegação entre telas.

**O que será implementado:**
* Validação das credenciais com exibição de mensagem de erro ("Credenciais inválidas")
* Navegação para a tela principal após login bem-sucedido
* Tela de produtos (Loja Online) com grid de cards, cada um sendo um Widget reutilizável que recebe nome, descrição e preço como parâmetros
* Botão de logout que retorna à tela de login

---

### Etapa 3 — HTTP, JSON e Persistência Local
Integração com API externa e armazenamento de dados no dispositivo.

**O que será implementado:**
* Autenticação via API fake (ex.: [fakestoreapi.com](https://fakestoreapi.com/))
* Consulta e exibição dos produtos reais retornados pela API, com imagens, nome, descrição e preço
* Salvamento das credenciais no dispositivo para reautenticação automática ao reabrir o app
* Uso de `Future`, `async`/`await`, `http` e `shared_preferences`

---

### Etapa 4 — Carrinho de Compras (Consolidação)
Conclusão do fluxo de compra com carrinho funcional.

**O que será implementado:**
* Ao clicar em "Comprar", exibir uma notificação (SnackBar) informando que o produto foi adicionado ao carrinho
* Tela "Meu Carrinho" acessível pelo ícone no topo, exibindo os itens, quantidade e total
* Opções para aumentar/diminuir quantidade ou remover itens do carrinho
* Botão de "Confirmar Compra"

---

## 🛠️ Tecnologias

* **Linguagem:** Dart
* **Framework:** Flutter
* **HTTP:** pacote `http`
* **Persistência:** `shared_preferences`
* **API:** [Fake Store API](https://fakestoreapi.com/)
* **IDE:** VS Code / Android Studio

---

## 💻 Pré-requisitos

Antes de começar, você vai precisar ter instalado em sua máquina:
* [Git](https://git-scm.com) para clonar o repositório.
* [Flutter SDK](https://flutter.dev/docs/get-started/install) configurado e funcionando (`flutter doctor` sem erros).
* [VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio) com as extensões do Flutter/Dart instaladas.

## 🚀 Como executar o projeto

1. Clone este repositório:
   ```bash
   git clone https://github.com/AppLab-Mobile-UFRN-2026-1/App-E-commerce.git
   ```
2. Acesse a pasta do projeto:
   ```bash
   cd App-E-commerce
   ```
3. Instale as dependências:
   ```bash
   flutter pub get
   ```
4. Conecte um dispositivo físico ou inicie um emulador.

5. Execute o aplicativo:
   ```bash
   flutter run
   ```

---

## 👥 Equipe de Desenvolvimento

| [<img src="https://avatars.githubusercontent.com/leonardonadson" width=115><br><sub>Leonardo Nadson</sub>](https://github.com/leonardonadson) | [<img src="https://avatars.githubusercontent.com/luan-sampaio" width=115><br><sub>Luan Sampaio</sub>](https://github.com/luan-sampaio) | [<img src="https://avatars.githubusercontent.com/MarcusAurelius33" width=115><br><sub>Marcus Aurelius</sub>](https://github.com/MarcusAurelius33) |
| :---: | :---: | :---: |
