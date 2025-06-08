import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LikedCubit extends Cubit<Set<String>> {
  LikedCubit() : super(<String>{}) {
    _restore();
  }

  static const _key = 'liked_films';

  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    emit(prefs.getStringList(_key)?.toSet() ?? <String>{});
  }

  Future<void> toggle(String filmId) async {
    final current = Set<String>.from(state);
    current.contains(filmId) ? current.remove(filmId) : current.add(filmId);
    emit(current);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, current.toList());
  }

  bool isLiked(String id) => state.contains(id);
}
