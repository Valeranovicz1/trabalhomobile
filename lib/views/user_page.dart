import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/utils/app_colors.dart';
import 'package:projetomobile/services/api_service.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.currentUser == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            });
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              _UserProfileContent(key: ValueKey(viewModel.currentUser!.id)),
              if (viewModel.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.netflixRed,
                    ),
                  ),
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

  final ImagePicker _picker = ImagePicker();

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

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.lightBackground,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.white),
                title: const Text(
                  'Galeria',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  'Câmera',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        if (!mounted) return;
        final authViewModel = Provider.of<AuthViewModel>(
          context,
          listen: false,
        );

        final success = await authViewModel.updateProfilePhoto(imageFile);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                success ? 'Foto atualizada!' : 'Erro ao enviar foto.',
              ),
              backgroundColor: success ? AppColors.success : AppColors.error,
            ),
          );
        }
      }
    } catch (e) {}
  }

  String getFullImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) {
      if (path.contains('localhost') || path.contains('127.0.0.1')) {
        return path
            .replaceAll('localhost', '10.0.2.2')
            .replaceAll('127.0.0.1', '10.0.2.2');
      }
      return path;
    }
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '${ApiService.baseUrl}/$cleanPath';
  }

  Future<bool> _showConfirmationDialog(String title, String content) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: AppColors.lightBackground,
            title: Text(title, style: const TextStyle(color: Colors.white)),
            content: Text(
              content,
              style: const TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.netflixRed,
                ),
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _onUpdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final viewModel = Provider.of<AuthViewModel>(context, listen: false);
    final success = await viewModel.updateUser(
      newName: _nameController.text,
      newPassword: _passwordController.text,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Perfil atualizado!' : 'Erro ao atualizar.'),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
      if (success) {
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    }
  }

  void _onLogout() async {
    final confirmed = await _showConfirmationDialog(
      'Sair?',
      'Deseja sair do app?',
    );
    if (confirmed && mounted) {
      await Provider.of<AuthViewModel>(context, listen: false).logout();
      if (mounted)
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }

  void _onDeleteAccount() async {
    final confirmed = await _showConfirmationDialog(
      'Deletar Conta?',
      'Essa ação é irreversível.',
    );
    if (confirmed && mounted) {
      await Provider.of<AuthViewModel>(context, listen: false).deleteAccount();
      if (mounted)
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, viewModel, child) {
        final user = viewModel.currentUser!;

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
                        radius: 60,
                        backgroundColor: AppColors.darkGray,
                        backgroundImage: user.imageUrl != null
                            ? NetworkImage(getFullImageUrl(user.imageUrl!))
                            : null,
                        child: user.imageUrl == null
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.lightGray,
                              )
                            : null,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.netflixRed,
                          child: IconButton(
                            iconSize: 20,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                            ),
                            onPressed: _showImagePickerOptions,
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
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.netflixRed),
                    ),
                  ),
                  validator: (val) =>
                      val!.trim().isEmpty ? 'Nome inválido' : null,
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Nova Senha (opcional)',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.netflixRed),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.netflixRed),
                    ),
                  ),
                  validator: (val) => val != _passwordController.text
                      ? 'Senhas não conferem'
                      : null,
                ),

                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _onUpdateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.netflixRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Atualizar Dados'),
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

                TextButton(
                  onPressed: _onDeleteAccount,
                  child: const Text(
                    'Deletar Conta',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
