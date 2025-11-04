import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/utils/app_colors.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meu Perfil')),
      body: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.currentUser == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            });
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              _UserProfileContent(
                key: ValueKey(viewModel.currentUser!.user_id),
              ),

              if (viewModel.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _UserProfileContent extends StatefulWidget {
  const _UserProfileContent({Key? key}) : super(key: key);

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
    final user = Provider.of<AuthViewModel>(context, listen: false).currentUser;
    _nameController = TextEditingController(text: user?.name ?? '');

    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
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

    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    final success = await viewModel.updateUser(
      newName: _nameController.text,
      newPassword: _passwordController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Perfil atualizado com sucesso!'
                : 'Falha ao atualizar. Pode ser necessário logar novamente.',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
      _passwordController.clear();
      _confirmPasswordController.clear();
    }
  }

  void _onDeleteAccount() async {
    final confirmed = await _showConfirmationDialog(
      'Deletar Conta?',
      'Esta ação é permanente e não pode ser desfeita.',
    );
    if (!confirmed) return;

    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    await viewModel.deleteAccount();
  }

  void _onLogout() async {
    final confirmed = await _showConfirmationDialog(
      'Sair da Conta?',
      'Você será desconectado.',
    );
    if (!confirmed) return;

    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    await viewModel.logout();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthViewModel>(
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
              decoration: const InputDecoration(
                labelText: 'Nova Senha (deixe em branco para manter)',
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty && value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar Nova Senha',
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
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
