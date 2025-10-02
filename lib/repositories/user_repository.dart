import 'package:projetomobile/models/user.dart';

class UserRepository {

  static final Map<String, User> _users = {};

  static int _nextId = 1;

  static bool registerUser({
    required String name,
    required String email,
    required String password,
  }) {

    if (_users.containsKey(email)) {
      print('Tentativa de registro falhou: email $email já existe.');
      return false;
    }

    final id = _nextId;

    _users[email] = User(user_id: id, name: name, email: email, password: password);

    _nextId++;

    print('Novo usuário registrado: $name com email $email.');
    print('Total de usuários agora: ${_users.length}');
    return true;
  }

  static User? loginUser({
    required String email,
    required String password,
  }) {
    final user = _users[email];
    
    if (user != null && user.password == password) {
      print('Login bem-sucedido para: ${user.name}');
      return user;
    }
    
    print('Tentativa de login falhou para o email: $email');
    return null;
  }
}
