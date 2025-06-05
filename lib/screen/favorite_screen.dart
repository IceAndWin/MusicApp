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
  List<Song> favorites = [];
  @override
  void didChangeDependencies() {
    _loadFavorites();
    super.didChangeDependencies();
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
                  Song song = favorites[index];
                  return _buildListTile(song);
                },
              ),
    );
  }

  Future<void> _loadFavorites() async {
    List<Song> songs = Provider.of<List<Song>>(context, listen: false);
    List<int> favIds = await FavoriteManager.getFavorites();
    setState(() {
      favorites = songs.where((song) => favIds.contains(song.id)).toList();
    });
  }

  ListTile _buildListTile(Song song) {
    return ListTile(
      onTap: () {
        smoothNavigation(
          replace: false,
          context,
          AudioPlayerScreen(
            title: song.title,
            artist: song.artist,
            imagePath: song.imagePath,
            songId: song.id,
            path: song.path,
          ),
        );
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child:
            (song.imagePath != null && File(song.imagePath!).existsSync())
                ? Image.file(
                  File(song.imagePath!),
                  fit: BoxFit.cover,
                  width: 50,
                  height: 50,
                )
                : Icon(Icons.music_note, size: 50, color: Colors.grey),
      ),
      title: text(
        song.title,
        16,
        FontWeight.w600,
        Colors.white,
        true,
        TextAlign.start,
      ),
      subtitle: Text(song.artist),
      trailing: showSongMenu(
        context,
        text1: 'Добавить в очередь',
        text2: 'Добавить в избранное',
        text3: 'Удалить из избранного',
        onTap1: () {},
        onTap2: () async {
          await FavoriteManager.addFavorite(song.id);
          await _loadFavorites();
        },
        onTap3: () {
          showAppDialog(
            context,
            title: "Удалить песню",
            content: "Вы уверены, что хотите удалить эту песню?",
            onPressed: () {
              FavoriteManager.removeFavorite(song.id);
              Navigator.pop(context);
              setState(() {
                favorites.removeWhere((favSong) => favSong.id == song.id);
              });
            },
          );
        },
      ),
    );
  }
}
