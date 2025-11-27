import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for managing saved articles
final savedArticlesProvider = StateNotifierProvider<SavedArticlesNotifier, List<String>>((ref) {
  return SavedArticlesNotifier();
});

class SavedArticlesNotifier extends StateNotifier<List<String>> {
  SavedArticlesNotifier() : super([]);

  void addArticle(String title) {
    if (!state.contains(title)) {
      state = [...state, title];
    }
  }

  void removeArticle(String title) {
    state = state.where((article) => article != title).toList();
  }

  bool isArticleSaved(String title) {
    return state.contains(title);
  }
}