import 'package:flutter/material.dart';
import 'package:music_project/consts.dart';
import "package:music_project/models/song.dart";
import 'package:music_project/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SongModel> songs = [];
  final List<Song> songsCard = List.generate(30, (index) {
    return Song(
      title: "Song Title $index",
      artist: "Artist $index",
      imagePath: "assets/cards/music_card.png",
      id: index,
    );
  });
  Future<void> requestStoragePermisson() async {
    if (await Permission.audio.isGranted) {
      fetchSongs();
    } else {
      if (mounted) {
        scaffoldMessenger(
          context,
          "Пожалуйста, предоставьте разрешение на доступ к аудио",
        );
        // TODO Настроики
        // openAppSettings();
      }
    }
  }

  Future<void> fetchSongs() async {
    final OnAudioQuery audioQuery = OnAudioQuery();
    List<SongModel> fetchedSongs = await audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    setState(() {
      songs = fetchedSongs;
    });
  }

  @override
  void initState() {
    requestStoragePermisson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorHomePage,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: const Color.fromARGB(255, 19, 22, 42),
            floating: true,
            snap: true,
            pinned: true,
            centerTitle: true,
            title: _buildSearchBar(),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(150),
              child: Container(
                margin: const EdgeInsets.only(right: 20, left: 20, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Название сортировки
                    Expanded(
                      child: Text(
                        'В случайном порядке', // Можно заменить на переменную для динамики
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.sort, color: Colors.white),
                      onPressed: () {
                        _buildShowModalBottomSheet(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 20)),
          buildMusicCard(songsCard),
        ],
      ),
    );
  }

  Future<dynamic> _buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.sort_by_alpha),
              title: Text("По алфавиту"),
              onTap: () {
                // TODO: сортировка по алфавиту
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shuffle),
              title: Text("В случайном порядке"),
              onTap: () {
                // TODO: случайная сортировка
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        height: 48,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Search',
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            prefixIcon: const Icon(Icons.search, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Color(0xFFEEF0F5),
          ),
        ),
      ),
    );
  }
}
