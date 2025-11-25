import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resource_article.dart';
import '../services/resource_service.dart';

final resourceProvider = FutureProvider.autoDispose<List<ResourceArticle>>((ref) async {
  return ResourceService.createDefault().fetchArticles();
});
