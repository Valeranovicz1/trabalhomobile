// lib/views/user_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/viewmodels/user_profile_viewmodel.dart';
import 'package:projetomobile/utils/app_colors.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProfileViewModel(
        Provider.of<AuthViewModel>(context, listen: false),
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Meu Perfil')),
        body: Consumer<UserProfileViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.currentUser == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                _UserProfileContent(),

                if (viewModel.isLoading)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _UserProfileContent extends StatefulWidget {
  @override
  _UserProfileContentState createState() => _UserProfileContentState();
}

class _UserProfileContentState extends State<_UserProfileContent> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProfileViewModel>(
      context,
      listen: false,
    ).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');
    _passwordController = TextEditingController(text: user?.password ?? '');
    _confirmPasswordController = TextEditingController(
      text: user?.password ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.lightBackground,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.netflixRed),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _onUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final confirmed = await _showConfirmationDialog(
      'Atualizar Perfil?',
      'Seus dados serão alterados.',
    );

    if (!confirmed) return;

    final viewModel = Provider.of<UserProfileViewModel>(context, listen: false);
    final success = await viewModel.updateUser(
      newName: _nameController.text,
      newPassword: _passwordController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success ? 'Perfil atualizado com sucesso!' : 'Falha ao atualizar.',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  void _onDeleteAccount() async {
    final confirmed = await _showConfirmationDialog(
      'Deletar Conta?',
      'Esta ação é permanente e não pode ser desfeita. Todos os seus dados serão perdidos.',
    );

    if (!confirmed) return;

    final viewModel = Provider.of<UserProfileViewModel>(context, listen: false);
    final success = await viewModel.deleteAccount();

    if (mounted && success) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    } else if (mounted && !success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao deletar a conta.'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onLogout() async {
    final confirmed = await _showConfirmationDialog(
      'Sair da Conta?',
      'Você será desconectado da sua conta.',
    );

    if (!confirmed) return;

    final viewModel = Provider.of<UserProfileViewModel>(context, listen: false);
    viewModel.logout();

    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProfileViewModel>(
      context,
      listen: false,
    ).currentUser!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.darkGray,
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.lightGray,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.netflixRed,
                      child: IconButton(
                        iconSize: 20,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: AppColors.white,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Upload de foto em breve!'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.lightGray,
                ),
              ),
            ),
            const SizedBox(height: 32),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Nome não pode ficar em branco'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nova Senha'),
              validator: (value) => (value == null || value.length < 6)
                  ? 'A senha deve ter pelo menos 6 caracteres'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Nova Senha',
              ),
              validator: (value) => (value != _passwordController.text)
                  ? 'As senhas não coincidem'
                  : null,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _onUpdateProfile,
              child: const Text('Atualizar Perfil'),
            ),

            const SizedBox(height: 40),
            const Divider(color: AppColors.darkGray),
            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGray,
                foregroundColor: AppColors.white,
              ),
              onPressed: _onLogout,
              child: const Text('Sair (Logout)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: AppColors.error,
                elevation: 0,
                side: const BorderSide(color: AppColors.error, width: 1),
              ),
              onPressed: _onDeleteAccount,
              child: const Text('Deletar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
