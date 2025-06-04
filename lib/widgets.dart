import 'package:flutter/material.dart';
import 'package:music_project/pages/audio_player_screen.dart';
import "models/song.dart";

void scaffoldMessenger(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

Widget buildMusicCard(List<Song> songs) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(childCount: songs.length, (
      context,
      index,
    ) {
      final song = songs[index % songs.length];
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
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            song.imagePath,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) =>
                    const Icon(Icons.music_note, size: 50, color: Colors.white),
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(song.artist),
        trailing: showSongMenu(songs, context),
      );
    }),
  );
}

PopupMenuButton showSongMenu(List<Song> songs, BuildContext context) {
  return PopupMenuButton(
    itemBuilder: (context) {
      return [
        PopupMenuItem(
          value: 0,
          child: Text('Добавить в очередь'),
          onTap: () {},
        ),
        PopupMenuItem(
          value: 1,
          child: Text('Добавить в избранное'),
          onTap: () {},
        ),
        PopupMenuItem(value: 2, child: Text('Удалить'), onTap: () {}),
      ];
    },
  );
}

void smoothNavigation(
  BuildContext context,
  Widget page, {
  bool replace = false,
}) {
  if (replace) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
