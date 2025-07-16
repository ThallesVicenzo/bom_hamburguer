# 🍔 Bom Hambúrguer

*### 📱 App Preview

<div align="center">
  <h4>🏠 Home Screen</h4>
  <p>Browse through our delicious hamburger menu</p>
  <img src="previews/home_scree### 📱 Prévia do App

<div align="center">
  <h4>🏠 Tela Inicial</h4>
  <p>Navegue pelo nosso delicioso menu de hambúrgueres</p>
  <img src="previews/home_screen_pt.png" alt="Tela Inicial - Português" width="300"/>
  
  <h4>🛒 Carrinho de Compras</h4>
  <p>Gerencie os itens do seu pedido com facilidade</p>
  <img src="previews/cart_screen_pt.png" alt="Tela do Carrinho - Português" width="300"/>
  
  <h4>✅ Finalização</h4>
  <p>Complete seu pedido com um processo simples de checkout</p>
  <img src="previews/checkout_screen_pt.png" alt="Tela de Checkout - Português" width="300"/>
</div>Home Screen - English" width="300"/>
  
  <h4>🛒 Shopping Cart</h4>
  <p>Manage your order items with ease</p>
  <img src="previews/cart_screen_en.png" alt="Cart Screen - English" width="300"/>
  
  <h4>✅ Checkout</h4>
  <p>Complete your order with a simple checkout process</p>
  <img src="previews/checkout_screen_en.png" alt="Checkout Screen - English" width="300"/>
</div>rtuguês) | [English](#english)*

---

## English

### 📱 About

**Bom Hambúrguer** is a modern Flutter mobile application for hamburger ordering. The app provides an intuitive interface for browsing products, managing cart items, and completing orders with a clean and responsive design.

### ✨ Features

- **Product Catalog**: Browse through different types of hamburgers and food items
- **Shopping Cart**: Add, remove, and manage items in your cart
- **Order Management**: Complete checkout process with order summary
- **Internationalization**: Full support for English and Portuguese (Brazil)
- **Local Database**: SQLite integration for data persistence
- **Responsive Design**: Optimized for different screen sizes
- **Clean Architecture**: MVVM pattern with dependency injection

### � App Preview

<div align="center">
  <h4>🏠 Home Screen</h4>
  <p>Browse through our delicious hamburger menu</p>
  <!-- Add your home screen screenshot here -->
  
  <h4>🛒 Shopping Cart</h4>
  <p>Manage your order items with ease</p>
  <!-- Add your cart screen screenshot here -->
  
  <h4>✅ Checkout</h4>
  <p>Complete your order with a simple checkout process</p>
  <!-- Add your checkout screen screenshot here -->
</div>

### �🛠️ Technologies Used

- **Framework**: Flutter 3.4.3+
- **State Management**: Provider
- **Navigation**: GoRouter
- **Database**: SQLite (sqflite)
- **Dependency Injection**: GetIt
- **Architecture**: MVVM (Model-View-ViewModel)
- **Internationalization**: Flutter Intl
- **Functional Programming**: Dartz

### 📦 Dependencies

```yaml
dependencies:
  flutter: sdk
  flutter_localizations: sdk
  provider: ^6.1.2
  go_router: ^16.0.0
  sqflite: ^2.3.0
  get_it: ^7.6.4
  dartz: any
  equatable: ^2.0.7
  intl: any
```

### 🚀 Getting Started

#### Prerequisites

- Flutter SDK (3.4.3 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (for iOS)

#### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/bom_hamburguer.git
   cd bom_hamburguer
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- ⚠️ Web (not optimized)
- ⚠️ Desktop (not optimized)

### 🏗️ Project Structure

```
lib/
├── injector.dart           # Dependency injection setup
├── main.dart              # Application entry point
├── l10n/                  # Internationalization files
├── models/                # Data models
│   ├── cart_item.dart
│   └── product.dart
├── repositories/          # Data layer
│   └── product_repository.dart
├── services/              # Business logic services
│   ├── cart_service.dart
│   └── database_service.dart
├── viewmodels/            # View models (MVVM)
│   ├── checkout_viewmodel.dart
│   └── home_screen_viewmodel.dart
└── views/                 # UI screens and widgets
    ├── checkout_screen.dart
    ├── home_screen.dart
    └── widgets/
```

### 🧪 Testing

Run tests using:

```bash
flutter test
```

### 📋 Available Scripts

- `flutter run`: Start the development server
- `flutter build apk`: Build Android APK
- `flutter build ios`: Build iOS app
- `flutter test`: Run unit tests
- `flutter gen-l10n`: Generate localization files

## Português

### 📱 Sobre

**Bom Hambúrguer** é um aplicativo móvel moderno desenvolvido em Flutter para pedidos de hambúrgueres. O app oferece uma interface intuitiva para navegar pelos produtos, gerenciar itens do carrinho e finalizar pedidos com um design limpo e responsivo.

### ✨ Funcionalidades

- **Catálogo de Produtos**: Navegue por diferentes tipos de hambúrgueres e comidas
- **Carrinho de Compras**: Adicione, remova e gerencie itens no seu carrinho
- **Gestão de Pedidos**: Processo completo de checkout com resumo do pedido
- **Internacionalização**: Suporte completo para Inglês e Português (Brasil)
- **Banco de Dados Local**: Integração SQLite para persistência de dados
- **Design Responsivo**: Otimizado para diferentes tamanhos de tela
- **Arquitetura Limpa**: Padrão MVVM com injeção de dependência

### � Prévia do App

<div align="center">
  <h4>🏠 Tela Inicial</h4>
  <p>Navegue pelo nosso delicioso menu de hambúrgueres</p>
  <!-- Adicione aqui a captura da tela inicial -->
  
  <h4>🛒 Carrinho de Compras</h4>
  <p>Gerencie os itens do seu pedido com facilidade</p>
  <!-- Adicione aqui a captura da tela do carrinho -->
  
  <h4>✅ Finalização</h4>
  <p>Complete seu pedido com um processo simples de checkout</p>
  <!-- Adicione aqui a captura da tela de checkout -->
</div>

### �🛠️ Tecnologias Utilizadas

- **Framework**: Flutter 3.4.3+
- **Gerenciamento de Estado**: Provider
- **Navegação**: GoRouter
- **Banco de Dados**: SQLite (sqflite)
- **Injeção de Dependência**: GetIt
- **Arquitetura**: MVVM (Model-View-ViewModel)
- **Internacionalização**: Flutter Intl
- **Programação Funcional**: Dartz

### 📦 Dependências

```yaml
dependencies:
  flutter: sdk
  flutter_localizations: sdk
  provider: ^6.1.2
  go_router: ^16.0.0
  sqflite: ^2.3.0
  get_it: ^7.6.4
  dartz: any
  equatable: ^2.0.7
  intl: any
```

### 🚀 Como Começar

#### Pré-requisitos

- Flutter SDK (3.4.3 ou superior)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (para iOS)

#### Instalação

1. **Clone o repositório**
   ```bash
   git clone https://github.com/yourusername/bom_hamburguer.git
   cd bom_hamburguer
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Gere os arquivos de localização**
   ```bash
   flutter gen-l10n
   ```

4. **Execute a aplicação**
   ```bash
   flutter run
   ```

### 📱 Plataformas Suportadas

- ✅ Android
- ✅ iOS
- ⚠️ Web (não otimizado)
- ⚠️ Desktop (não otimizado)

### 🏗️ Estrutura do Projeto

```
lib/
├── injector.dart           # Configuração de injeção de dependência
├── main.dart              # Ponto de entrada da aplicação
├── l10n/                  # Arquivos de internacionalização
├── models/                # Modelos de dados
│   ├── cart_item.dart
│   └── product.dart
├── repositories/          # Camada de dados
│   └── product_repository.dart
├── services/              # Serviços de lógica de negócio
│   ├── cart_service.dart
│   └── database_service.dart
├── viewmodels/            # View models (MVVM)
│   ├── checkout_viewmodel.dart
│   └── home_screen_viewmodel.dart
└── views/                 # Telas e widgets de UI
    ├── checkout_screen.dart
    ├── home_screen.dart
    └── widgets/
```

### 🧪 Testes

Execute os testes usando:

```bash
flutter test
```

### 📋 Scripts Disponíveis

- `flutter run`: Inicia o servidor de desenvolvimento
- `flutter build apk`: Constrói APK Android
- `flutter build ios`: Constrói app iOS
- `flutter test`: Executa testes unitários
- `flutter gen-l10n`: Gera arquivos de localização

## 📸 Screenshots

### English Version (Good Burger)

<p align="center">
  <img src="previews/home_screen_en.png" alt="Welcome screen with burgers and sides menu" width="250"/>
  <img src="previews/cart_screen_en.png" alt="Cart with items and order summary" width="250"/>
  <img src="previews/order_confirmation_en.png" alt="Order confirmation with discount details" width="250"/>
</p>

**Features shown:**
- 🏠 **Home Screen**: Welcome message, hamburger menu, sides section, and special promotions
- 🛒 **Cart Management**: Add/remove items, automatic discount calculation (20% combo discount)
- ✅ **Order Confirmation**: Instant confirmation with total amount and applied discounts

### Versão em Português (Bom Hambúrguer)

<p align="center">
  <img src="previews/home_screen_pt.png" alt="Tela inicial com hambúrgueres e promoções" width="250"/>
  <img src="previews/cart_screen_pt.png" alt="Carrinho com itens e resumo do pedido" width="250"/>
  <img src="previews/order_confirmation_pt.png" alt="Confirmação de pedido com detalhes do desconto" width="250"/>
</p>

**Funcionalidades mostradas:**
- 🏠 **Tela Inicial**: Mensagem de boas-vindas, menu de hambúrgueres, acompanhamentos e promoções especiais
- 🛒 **Gestão do Carrinho**: Adicionar/remover itens, cálculo automático de desconto (20% desconto combo)
- ✅ **Confirmação do Pedido**: Confirmação instantânea com valor total e descontos aplicados

### Additional Features / Funcionalidades Adicionais

- 🎯 **Smart Discounts**: Automatic combo detection (Sandwich + Fries + Drink = 20% off)
- 🌍 **Bilingual Support**: Complete interface in English and Portuguese
- 💾 **Persistent Cart**: SQLite database maintains cart state
- 🎨 **Consistent UI**: Orange theme with intuitive design patterns

## 🔗 Useful Links / Links Úteis

- [Flutter Documentation](https://docs.flutter.dev/)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [SQLite Package](https://pub.dev/packages/sqflite)

---

*Made with ❤️ using Flutter*
