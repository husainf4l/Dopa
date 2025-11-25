import '../models/resource_article.dart';
import 'api_client.dart';

class ResourceService {
  ResourceService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ResourceArticle>> fetchArticles() async {
    final response = await _apiClient.client.get('/resources');
    return (response.data as List)
        .map((json) => ResourceArticle.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static ResourceService createDefault() => ResourceService(ApiClient());
}
