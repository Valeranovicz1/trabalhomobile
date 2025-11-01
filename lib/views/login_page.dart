import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/utils/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

    final success = await authViewModel.login(
      _emailController.text,
      _passwordController.text,
    );

    if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email ou senha inválidos.'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
    final authViewModel = Provider.of<AuthViewModel>(context);
    final bool isLoading = authViewModel.isLoading;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.darkBackground, Color(0xFF000000)],
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
                      _buildHeader(),
                      const SizedBox(height: 60),
                      _buildForm(isLoading),
                      const SizedBox(height: 40),
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

  Widget _buildHeader() {
    return Column(
      children: [
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
        const Text(
          'Seu catálogo pessoal de filmes',
          style: TextStyle(color: AppColors.lightGray, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: AppColors.lightGray),
              prefixIcon: const Icon(
                Icons.email_outlined,
                color: AppColors.lightGray,
              ),
              filled: true,
              fillColor: AppColors.darkGray,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.netflixRed,
                  width: 2,
                ),
              ),
              errorStyle: const TextStyle(color: AppColors.error),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            validator: _validatePassword,
            style: const TextStyle(color: AppColors.white, fontSize: 16),
            decoration: InputDecoration(
              labelText: 'Senha',
              labelStyle: const TextStyle(color: AppColors.lightGray),
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: AppColors.lightGray,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
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
                borderSide: const BorderSide(
                  color: AppColors.netflixRed,
                  width: 2,
                ),
              ),
              errorStyle: const TextStyle(color: AppColors.error),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.netflixRed,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: AppColors.mediumGray,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
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

  Widget _buildExtras() {
    return Column(
      children: [
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
        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.darkGray)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'ou',
                style: TextStyle(color: AppColors.lightGray, fontSize: 14),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.darkGray)),
          ],
        ),
        const SizedBox(height: 32),
        const SizedBox(height: 32),

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
              style: TextStyle(color: AppColors.lightGray, fontSize: 16),
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
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Text(
              'Novo no MovieDex? ',
              style: TextStyle(color: AppColors.lightGray, fontSize: 14),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
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
