# 🎬 MovieDex - Tela de Login

## 📋 Visão Geral

A tela de login do **MovieDex** foi desenvolvida seguindo as melhores práticas de UX/UI, inspirada no design da Netflix. Esta implementação foca na usabilidade, acessibilidade e experiência visual premium.

## 🎨 Design System - Paleta de Cores Netflix

### Cores Principais
- **Netflix Red**: `#E50914` - Cor principal da marca
- **Dark Background**: `#141414` - Fundo escuro principal  
- **Light Background**: `#181818` - Fundo escuro secundário

### Cores Neutras
- **White**: `#FFFFFF` - Texto principal em fundos escuros
- **Light Gray**: `#B3B3B3` - Texto secundário
- **Medium Gray**: `#808080` - Texto desabilitado
- **Dark Gray**: `#333333` - Elementos de interface

### Cores de Estado
- **Success**: `#46D369` - Confirmações e sucessos
- **Warning**: `#F5C842` - Avisos e atenções  
- **Error**: `#F40612` - Erros e validações

### Cores para Componentes

#### Input Fields
- **Background**: `#333333`
- **Border**: `#737373`
- **Border Focused**: `#E50914`
- **Text**: `#FFFFFF`
- **Placeholder**: `#8C8C8C`

#### Botões
- **Primary**: `#E50914`
- **Primary Hover**: `#F40612`
- **Secondary**: `#333333`
- **Disabled**: `#404040`

## ✨ Funcionalidades Implementadas

### 🔐 Autenticação
- **Validação de email** com regex pattern
- **Validação de senha** (mínimo 6 caracteres)
- **Toggle de visibilidade** da senha
- **Estado de loading** durante login
- **Checkbox "Lembrar de mim"**

### 🎨 Interface Visual
- **Gradiente de fundo** inspirado na Netflix
- **Animações suaves** de entrada (fade + slide)
- **Feedback visual** para estados de erro/sucesso
- **Design responsivo** que se adapta a diferentes tamanhos
- **Ícones contextuais** nos campos de input

### 📱 Experiência do Usuário
- **Formulário validado** com mensagens de erro claras
- **Snackbars informativos** para feedback
- **Loading states** com indicadores visuais
- **Links auxiliares** (esqueci senha, cadastro, login social)
- **Navegação intuitiva** entre campos

## 🏗️ Arquitetura

### Estrutura de Arquivos
```
lib/
├── utils/
│   └── app_colors.dart      # Sistema de cores centralizado
├── pages/
│   └── login.dart           # Tela de login principal
└── main.dart                # Configuração do app
```

### Componentes Principais

#### `AppColors`
- Classe utilitária com todas as cores do sistema
- Extensão para fácil acesso via context
- Organização por categorias (principal, texto, estado)

#### `LoginPage`
- Widget stateful com animações integradas
- Controladores para formulário e animações
- Validação robusta de campos
- Estados de loading e erro

## 🔧 Implementação Técnica

### Validações
```dart
// Email
final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

// Senha
if (value.length < 6) {
  return 'A senha deve ter pelo menos 6 caracteres';
}
```

### Animações
- **FadeTransition**: Entrada suave da tela
- **SlideTransition**: Movimento de baixo para cima
- **Duration**: 1200-1500ms para transições naturais

### Estado de Loading
```dart
_isLoading ? CircularProgressIndicator() : Text('Entrar')
```

## 🚀 Como Executar

1. **Certifique-se de ter o Flutter instalado**
```bash
flutter doctor
```

2. **Execute o projeto**
```bash
cd trabalhomobile
flutter run
```

3. **Para hot reload durante desenvolvimento**
```bash
# Pressione 'r' no terminal ou salve os arquivos no VS Code
```

## 📝 Validações Implementadas

### Campo Email
- ✅ Obrigatório
- ✅ Formato de email válido
- ✅ Feedback visual instantâneo

### Campo Senha  
- ✅ Obrigatório
- ✅ Mínimo 6 caracteres
- ✅ Toggle visibilidade
- ✅ Mensagens de erro contextuais

### Formulário
- ✅ Validação em tempo real
- ✅ Prevenção de submit inválido
- ✅ Estados de loading
- ✅ Feedback de sucesso/erro

## 🎯 Próximos Passos

### Funcionalidades Futuras
- [ ] Integração com backend de autenticação
- [ ] Login social (Google, Facebook)
- [ ] Recuperação de senha
- [ ] Biometria (fingerprint/face)
- [ ] Persistência de sessão
- [ ] Tema claro/escuro

### Melhorias de UX
- [ ] Animações mais elaboradas
- [ ] Micro-interações
- [ ] Haptic feedback
- [ ] Localização (i18n)
- [ ] Acessibilidade completa

## 🔍 Testes

### Como Testar a Validação
1. **Email inválido**: Digite `teste@` → Deve mostrar erro
2. **Senha curta**: Digite `123` → Deve mostrar erro  
3. **Campos vazios**: Tente fazer login → Deve mostrar erros
4. **Dados válidos**: Use `test@email.com` + senha `123456` → Deve simular login

### Estados Visuais
- **Loading**: Clique em "Entrar" com dados válidos
- **Erro**: Use dados inválidos
- **Sucesso**: Complete o login corretamente

## 📱 Responsividade

A tela é otimizada para:
- **Smartphones** (360px - 414px)
- **Tablets** (768px - 1024px) 
- **Orientação** portrait e landscape
- **Diferentes densidades** de pixel

## 🎨 Tokens de Design

### Spacing
- **Small**: 8px
- **Medium**: 16px  
- **Large**: 24px
- **XLarge**: 32px

### Typography
- **Title**: 32px, Bold
- **Subtitle**: 16px, Light
- **Body**: 16px, Regular
- **Caption**: 14px, Regular

### Border Radius
- **Inputs**: 8px
- **Buttons**: 8px
- **Cards**: 12px

---

**Desenvolvido por**: [Seu Nome]  
**Data**: Outubro 2025  
**Framework**: Flutter 3.9.2  
**Tema**: Inspirado na Netflix