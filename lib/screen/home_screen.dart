import 'package:flutter/material.dart';
import 'package:music_project/constants.dart';
import 'package:music_project/models/song.dart';

import 'package:music_project/screen/favorite_screen.dart';
import 'package:music_project/screen/songs_list_screen.dart';
import 'package:music_project/widgets.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SongModel> _songs = [];
  final List<Widget> _pages = [];
  final OnAudioQuery _audioQuery = OnAudioQuery();
  int _currentIndex = 0;
  Future<void> requestStoragePermisson() async {
    Permission permisson1 = Permission.storage;
    Permission permisson2 = Permission.manageExternalStorage;
    final status1 = await permisson1.status;
    final status2 = await permisson2.status;
    if (status1.isDenied && status2.isDenied) {
      final result = await permisson1.request();
      if (result.isGranted) {
        fetchSongs();
      } else {
        debugPrint("Permission denied");
        if (mounted) {
          showAppDialog(
            context,
            title: "Нет разрешений",
            content: "Пожалуйста, предоставьте доступ к аудио",
            onPressed: () {
              openAppSettings();
            },
          );
        }
      }
    } else if (status1.isGranted || status2.isGranted) {
      fetchSongs();
    } else {
      debugPrint("Permission is not granted");
      if (mounted) {
        scaffoldMessenger(context, "Пожалуйста, предоставьте доступ к аудио");
      }
    }
  }

  Future<void> fetchSongs() async {
    List<SongModel> data = await _audioQuery.querySongs(
      sortType: SongSortType.TITLE,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    List<SongModel> filteredSongs =
        data.where((element) {
          return !(element.data.toString().toLowerCase().endsWith(".ogg"));
        }).toList();
    setState(() {
      _songs = filteredSongs;
      if (_songs.isEmpty) {
        scaffoldMessenger(context, "Нет песен в вашей библиотеке");
        return;
      }
      _pages.add(SongsListScreen(songs: convertToCustomSongs(_songs)));
      _pages.add(FavoriteScreen());
    });
  }

  List<Song> convertToCustomSongs(List<SongModel> songs) {
    return songs.map((model) {
      return Song(
        title: model.title,
        artist: model.artist ?? "Неизвестный исполнитель",
        imagePath: model.uri,
        id: model.id,
        path: model.data,
      );
    }).toList();
  }

  @override
  void initState() {
    requestStoragePermisson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => convertToCustomSongs(_songs),
      child: Scaffold(
        backgroundColor: kBackgroundColorHomeScreen,
        body:
            _pages.isNotEmpty
                ? _pages[_currentIndex]
                : Center(child: CircularProgressIndicator()),
        bottomNavigationBar: BottomNavigationBar(
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.white),
          unselectedItemColor: Colors.white,
          selectedItemColor: Colors.red,
          selectedIconTheme: IconThemeData(color: Colors.red),
          backgroundColor: kBackgroundColorHomeScreen,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.music_note,
                color: _currentIndex == 0 ? Colors.red : Colors.white,
              ),
              label: "Главная",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: _currentIndex == 1 ? Colors.red : Colors.white,
              ),
              label: "Избранное",
            ),
          ],
        ),
      ),
    );
  }
}
