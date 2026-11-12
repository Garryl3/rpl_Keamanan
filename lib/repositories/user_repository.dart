import '../models/user.dart';

/// Abstraksi repository untuk mengelola data pengguna.
abstract class UserRepository {
  Future<List<User>> getUsers();
  Future<User> getUserById(int id);
}