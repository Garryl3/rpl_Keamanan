import 'package:flutter/material.dart';
import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart' hide PostRepository;
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

class DependencyInjector extends InheritedWidget {
  final ApiService apiService;
  final UserRepository userRepository;
  final PostRepository postRepository;

  DependencyInjector({
    super.key,
    required super.child,
    ApiService? apiService,
    UserRepository? userRepository,
    PostRepository? postRepository,
  })  : apiService = apiService ?? ApiService(),
        userRepository = userRepository ?? UserRepositoryImpl(),
        postRepository = postRepository ?? PostRepositoryImpl();

  static DependencyInjector of(BuildContext context) {
    final DependencyInjector? result =
        context.dependOnInheritedWidgetOfExactType<DependencyInjector>();
    assert(result != null, 'No DependencyInjector found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(DependencyInjector oldWidget) => false;
}