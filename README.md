# 🎬 MovieDex

Um catálogo pessoal de filmes desenvolvido em Flutter, inspirado no design da Netflix.

## 📱 Sobre o Projeto

O **MovieDex** é um aplicativo mobile desenvolvido como projeto de programação mobile, funcionando como uma espécie de Letterboxd pessoal. O projeto utiliza Flutter e segue as melhores práticas de desenvolvimento, com arquitetura MVVM e design system inspirado na Netflix.

### ✨ Funcionalidades Atuais

- 🔐 **Tela de Login** completa com validações
- 🎨 **Design System** inspirado na Netflix
- 📱 **Interface responsiva** e moderna
- ✅ **Validações de formulário** em tempo real
- 🌙 **Tema escuro** por padrão

### 🎯 Funcionalidades Futuras

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
├── main.dart                 # Configuração principal do app
├── pages/
│   ├── login.dart           # Tela de login
│   ├── home_page.dart       # Tela principal (em desenvolvimento)
│   ├── movie_page.dart      # Tela de detalhes do filme
│   ├── register.dart        # Tela de cadastro
│   └── user_page.dart       # Tela do usuário
├── models/
│   ├── movie.dart           # Modelo de dados do filme
│   └── user.dart            # Modelo de dados do usuário
├── repositories/
│   └── movie_repository.dart # Repositório de filmes
└── utils/
    ├── app_colors.dart      # Sistema de cores
    └── app_constants.dart   # Constantes do app
```

## 👥 Equipe de Desenvolvimento

Este projeto está sendo desenvolvido em equipe, onde cada membro é responsável por uma parte específica:

- **Tela de Login** - ✅ Concluída
- **Tela Principal** - 🚧 Em desenvolvimento
- **Tela de Detalhes** - 🚧 Em desenvolvimento
- **Sistema de Busca** - 📋 Planejado

## 🛠️ Tecnologias Utilizadas

- **Flutter** 3.9.2
- **Dart** ^3.9.2
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
