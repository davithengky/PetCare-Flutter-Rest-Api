import '../../core/errors/app_exception.dart';
import '../models/user_model.dart';
import 'auth_repo.dart';

/// Implementasi mock repository untuk fitur autentikasi (in-memory data).
class MockAuthRepo implements AuthRepo {
  final List<User> _users = [
    const User(
      id: 1,
      name: 'Davit Hengky',
      email: 'davit@petcare.com',
      membershipTier: 'gold',
    ),
  ];

  final Map<int, String> _passwords = {
    1: '123456',
  };

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();
    final userIndex = _users.indexWhere(
      (u) => u.email.toLowerCase() == normalizedEmail,
    );

    if (userIndex == -1) {
      throw const AppException('Email atau password salah');
    }

    final user = _users[userIndex];
    if (_passwords[user.id] != password) {
      throw const AppException('Email atau password salah');
    }

    return user;
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 600));

    final normalizedEmail = email.trim().toLowerCase();
    final exists = _users.any(
      (u) => u.email.toLowerCase() == normalizedEmail,
    );

    if (exists) {
      throw const AppException('Email sudah terdaftar');
    }

    // Auto increment ID
    final newId = _users.isEmpty
        ? 1
        : _users.map((u) => u.id).reduce((a, b) => a > b ? a : b) + 1;

    final newUser = User(
      id: newId,
      name: name.trim(),
      email: normalizedEmail,
      membershipTier: 'basic',
    );

    _users.add(newUser);
    _passwords[newId] = password;

    return newUser;
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 400));

    if (_users.isEmpty) {
      throw const AppException('Pengguna tidak ditemukan');
    }

    final current = _users.first;
    final updated = current.copyWith(
      name: name ?? current.name,
      phone: phone ?? current.phone,
      address: address ?? current.address,
    );

    _users[0] = updated;
    return updated;
  }

  @override
  Future<void> logout() async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
