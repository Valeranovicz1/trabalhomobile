# 🎬 MovieDex

Um catálogo pessoal de filmes desenvolvido em Flutter, inspirado no design da Netflix.

Para acessar a API, acesse o link: https://github.com/maluquismos/projetomobile-api

## 📱 Sobre o Projeto

O **MovieDex** é um aplicativo mobile desenvolvido como projeto de programação mobile, funcionando como uma espécie de Letterboxd pessoal. O projeto utiliza Flutter e segue as melhores práticas de desenvolvimento, com arquitetura MVVM e design system inspirado na Netflix.

### ✨ Funcionalidades Atuais

- 🔐 **Tela de Login** completa com validações
- 🎨 **Design System** inspirado na Netflix
- 📱 **Interface responsiva** e moderna
- ✅ **Validações de formulário** em tempo real
- 🌙 **Tema escuro** por padrão
- 📋 Lista de filmes
- 🎬 Detalhes dos filmes
- ➕ Cadastro de novos filmes
- 🔍 Sistema de busca
- ⭐ Sistema de avaliações
- 👤 Perfil do usuário

## 🎨 Design System

O projeto utiliza uma paleta de cores inspirada na Netflix:

| Cor | Hexadecimal | Uso |
|-----|-------------|-----|
| **Netflix Red** | `#E50914` | Cor principal, botões, acentos |
| **Dark Background** | `#141414` | Fundo principal |
| **Light Background** | `#181818` | Fundo secundário |
| **White** | `#FFFFFF` | Texto principal |
| **Light Gray** | `#B3B3B3` | Texto secundário |

## 🚀 Como Executar

### Pré-requisitos

- Flutter SDK instalado
- Android Studio ou VS Code
- Emulador Android ou dispositivo físico

### Passos

1. **Clone o repositório:**
```bash
git clone https://github.com/Valeranovicz1/trabalhomobile.git
cd trabalhomobile
```

2. **Instale as dependências:**
```bash
flutter pub get
```

3. **Execute o projeto:**
```bash
flutter run
```

## 🧪 Testes

Execute os testes do projeto:

```bash
flutter test
```

## 📁 Estrutura do Projeto

```
lib/
├── main.dart             # Ponto de entrada, inicializa o app e o Firebase
├── app.dart              # Widget raiz do app (provavelmente o MaterialApp)
├── firebase_options.dart # Configurações específicas do Firebase (gerado)
│
├── models/        
│   ├── movie.dart          # Modelo de dados do Filme
│   ├── rating.dart         # Modelo de dados da Avaliação (feita por um usuário)
│   └── user.dart           # Modelo de dados do Usuário
│
├── repositories/        
│   └── movie_repository.dart # Repositório para buscar dados de filmes
│
├── utils/                
│    ├── app_colors.dart      # Sistema de cores
|    └── app_constants.dart   # Constantes do app refaça
|
├── viewmodels/           
│   ├── auth_viewmodel.dart         # Gerencia estado de autenticação (login, registro)
│   ├── home_viewmodel.dart         # Gerencia estado da tela principal (home)
│   ├── movie_detail_viewmodel.dart # Gerencia estado da tela de detalhes do filme
│   ├── movie_viewmodel.dart        # Lógica de estado geral relacionada a filmes
│   └── rating_viewmodel.dart       # Gerencia estado para criar/ver avaliações
│
└── views/             
    ├── auth_wrapper.dart       # Decide se mostra Login ou Home (verifica se está logado)
    ├── home_page.dart          # Tela principal (Catálogo de filmes)
    ├── login_page.dart         # Tela de login
    ├── movie_detail_page.dart  # Tela de detalhes de um filme específico
    ├── register_page.dart      # Tela de cadastro de novo usuário
    └── user_page.dart          # Tela de perfil do usuário
```

## 👥 Equipe de Desenvolvimento

Este projeto está sendo desenvolvido em equipe, onde cada membro é responsável por uma parte específica:

- **Tela de Login** - ✅ Concluída
- **Tela Principal** - ✅ Concluída
- **Tela de Detalhes** - ✅ Concluída
- **Sistema de Busca** - ✅ Concluída

## 🛠️ Tecnologias Utilizadas

- **Flutter** 3.9.2
- **Dart** ^3.9.2
- **Firebase**
- **Arquitetura MVVM**
- **Provider** (planejado para gerenciamento de estado)

## 📚 Documentação

- [Documentação da Tela de Login](docs/LOGIN_README.md)
- [Guia de Cores](lib/utils/app_colors.dart)

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/NovaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/NovaFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto é desenvolvido para fins educacionais.

---

**Desenvolvido com ❤️ em Flutter**
