import 'package:flutter/material.dart';
import '../../data/film.dart';
import '../widgets/film_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  late final Future<List<Film>> _filmsFuture = Film.loadFromAsset();
  final _pageCtrl = PageController();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<List<Film>>(
      future: _filmsFuture,
      builder: (_, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final films = snap.data!;
        return PageView.builder(
          key: const PageStorageKey('home_page'),  // remember position
          controller: _pageCtrl,
          scrollDirection: Axis.vertical,
          itemCount: films.length,
          itemBuilder: (_, i) => FilmCard(film: films[i]),
        );
      },
    );
  }
}
