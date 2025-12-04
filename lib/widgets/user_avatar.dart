import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/utils/app_colors.dart';
import 'package:projetomobile/services/api_service.dart';

class UserAvatar extends StatelessWidget {
  final double radius;
  final VoidCallback? onTap;

  final String? _specificUrl;
  final bool _useCurrentUser;

  const UserAvatar({super.key, this.radius = 20, this.onTap})
    : _useCurrentUser = true,
      _specificUrl = null;

  const UserAvatar.fromUrl({
    super.key,
    required String? url,
    this.radius = 20,
    this.onTap,
  }) : _useCurrentUser = false,
       _specificUrl = url;

  String _buildFullUrl(String path) {
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

  @override
  Widget build(BuildContext context) {
    if (_useCurrentUser) {
      return Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          return _buildCircle(authViewModel.currentUser?.imageUrl);
        },
      );
    } else {
      return _buildCircle(_specificUrl);
    }
  }

  Widget _buildCircle(String? url) {
    ImageProvider? imageProvider;

    if (url != null && url.isNotEmpty) {
      final fullUrl = _buildFullUrl(url);
      imageProvider = NetworkImage(fullUrl);
    }

    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.darkGray,
      backgroundImage: imageProvider,
      child: imageProvider == null
          ? Icon(Icons.person, size: radius * 1.5, color: AppColors.lightGray)
          : null,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: avatar,
      );
    }
    return avatar;
  }
}
