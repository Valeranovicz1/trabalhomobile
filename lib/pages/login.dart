import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetomobile/utils/app_colors.dart';

/// Tela de Login do MovieDex - Versão Simplificada
/// 
/// Nova implementação focada em:
/// - Design limpo sem áreas acinzentadas
/// - Layout simplificado
/// - Funcionalidades essenciais mantidas
/// 
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores para os campos de texto
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Chave do formulário para validação
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // Estados do formulário
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    
    // Configurar barras do sistema
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.darkBackground,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Função para realizar o login
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isLoading = true;
    });
    
    // Simular processo de login
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isLoading = false;
    });
    
    // Aqui você implementaria a lógica real de autenticação
    if (mounted) {
      // Navegar para a tela principal após login bem-sucedido
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  /// Validador para email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu email';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Por favor, insira um email válido';
    }
    
    return null;
  }

  /// Validador para senha
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.darkBackground,
              Color(0xFF000000),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo e Título
                      _buildHeader(),
                      
                      const SizedBox(height: 60),
                      
                      // Formulário
                      _buildForm(),
                      
                      const SizedBox(height: 40),
                      
                      // Opções extras
                      _buildExtras(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Constrói o cabeçalho
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: AppColors.netflixRed,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.movie_outlined,
            color: AppColors.white,
            size: 50,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Título
        const Text(
          'MovieDex',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtítulo
        const Text(
          'Seu catálogo pessoal de filmes',
          style: TextStyle(
            color: AppColors.lightGray,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  /// Constrói o formulário
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Campo Email
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: AppColors.lightGray),
              prefixIcon: const Icon(Icons.email_outlined, color: AppColors.lightGray),
              filled: true,
              fillColor: AppColors.darkGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.netflixRed, width: 2),
              ),
              errorStyle: const TextStyle(color: AppColors.error),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Campo Senha
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: _validatePassword,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Senha',
              labelStyle: const TextStyle(color: AppColors.lightGray),
              prefixIcon: const Icon(Icons.lock_outline, color: AppColors.lightGray),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  color: AppColors.lightGray,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              filled: true,
              fillColor: AppColors.darkGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.netflixRed, width: 2),
              ),
              errorStyle: const TextStyle(color: AppColors.error),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Botão de Login
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.netflixRed,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: AppColors.mediumGray,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                      ),
                    )
                  : const Text(
                      'Entrar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói as opções extras
  Widget _buildExtras() {
    return Column(
      children: [
        // Lembrar de mim e Esqueci senha
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      activeColor: AppColors.netflixRed,
                      checkColor: AppColors.white,
                      side: const BorderSide(color: AppColors.lightGray),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Flexible(
                    child: Text(
                      'Lembrar de mim',
                      style: TextStyle(
                        color: AppColors.lightGray,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: TextButton(
                onPressed: () {
                  // Implementar esqueci senha
                  debugPrint('Esqueci minha senha');
                },
                child: const Text(
                  'Esqueci senha',
                  style: TextStyle(
                    color: AppColors.lightGray,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 40),
        
        // Divisor
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.darkGray,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ou',
                style: TextStyle(
                  color: AppColors.lightGray,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.darkGray,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 32),
        
        // Botão Google
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              debugPrint('Login com Google');
            },
            icon: const Icon(
              Icons.g_mobiledata,
              color: AppColors.lightGray,
              size: 24,
            ),
            label: const Text(
              'Continuar com Google',
              style: TextStyle(
                color: AppColors.lightGray,
                fontSize: 16,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.darkGray),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // Link para cadastro
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Novo no MovieDex? ',
              style: TextStyle(
                color: AppColors.lightGray,
                fontSize: 14,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navegar para cadastro
                debugPrint('Navegar para cadastro');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Cadastre-se agora',
                style: TextStyle(
                  color: AppColors.netflixRed,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
