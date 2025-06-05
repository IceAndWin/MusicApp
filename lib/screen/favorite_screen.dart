import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_project/constants.dart';
import 'package:music_project/models/favorite_manager.dart';
import 'package:music_project/models/song.dart';
import 'package:music_project/screen/audio_player_screen.dart';
import 'package:music_project/widgets.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  // ignore: prefer_typing_uninitialized_variables
  late final favorites;
  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorHomeScreen,
      appBar: AppBar(
        backgroundColor: kBackgroundColorHomeScreen,
        title: text("Избраное", 24, FontWeight.normal, kWhiteColorAudioPlayer),
        centerTitle: true,
      ),
      body:
          favorites.isEmpty
              ? Center(
                child: text(
                  "Нет избранных песен",
                  18,
                  FontWeight.normal,
                  Colors.white,
                ),
              )
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return ChangeNotifierProvider.value(
                    value: favorites[index],
                    child: _buildListTile(favorites[index]),
                  );
                },
              ),
    );
  }

  Future<void> _loadFavorites() async {
    List<Song> allSongs = Provider.of<List<Song>>(context);
    List<int> favIds = await FavoriteManager.getFavorites();
    setState(() {
      favorites = allSongs.where((song) => favIds.contains(song.id)).toList();
    });
  }

  ListTile _buildListTile(BuildContext context) {
    return ListTile(
      onTap: () {
        smoothNavigation(
          replace: false,
          context,
          AudioPlayerScreen(
            title: Provider.of<Song>(context, listen: false).title,
            artist: Provider.of<Song>(context, listen: false).artist,
            imagePath: Provider.of<Song>(context, listen: false).imagePath,
            songId: Provider.of<Song>(context, listen: false).id,
            path: Provider.of<Song>(context, listen: false).path,
          ),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:
            (Provider.of<Song>(context, listen: false).imagePath != null &&
                    File(
                      Provider.of<Song>(context, listen: false).imagePath!,
                    ).existsSync())
                ? Image.file(
                  File(Provider.of<Song>(context, listen: false).imagePath!),
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                )
                : Icon(Icons.music_note, size: 50, color: Colors.grey),
      ),

      title: text(
        Provider.of<Song>(context, listen: false).title,
        16,
        FontWeight.w600,
        Colors.white,
        true,
        TextAlign.start,
      ),

      subtitle: Text(Provider.of<Song>(context, listen: false).artist),
      trailing: showSongMenu(
        context,
        text1: 'Добавить в очередь',
        text2: 'Добавить в избранное',
        text3: 'Удалить',
        onTap1: () {},
        onTap2: () {},
        onTap3: () {
          showAppDialog(
            context,
            title: "Удалить песню",
            content: "Вы уверены, что хотите удалить эту песню?",
            onPressed: () {
              //   try {
              //     File file = File(path);
              //     if (file.existsSync()) {
              //       await file.delete();
              //       scaffoldMessenger(context, "Песня удалена");
              //     } else {
              //       debugPrint("Файл не найден: ${path}");
              //     }
              //   } catch (e) {
              //     debugPrint("Файл не найден: ${path}");
              //     debugPrint("Ошибка при удалении песни: $e");
              //     scaffoldMessenger(context, "Ошибка при удалении песни");
              //   } finally {
              //     Navigator.of(context).pop();
              //   }
              // },
            },
          );
        },
      ),
    );
  }
}
