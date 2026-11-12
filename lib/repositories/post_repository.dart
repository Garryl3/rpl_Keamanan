import '../models/post.dart';
import '../services/api_service.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
}

class PostRepositoryImpl implements PostRepository {
  final ApiService _apiService;

  PostRepositoryImpl({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  @override
  Future<List<Post>> getPosts() async {
    return await _apiService.getPosts();
  }
}