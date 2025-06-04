import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_project/pages/audio_player_screen.dart';
import "models/song.dart";

// SCAFFOLD MESSENGER
void scaffoldMessenger(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

// MUSIC CARD
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
        trailing: showSongMenu(songs, context),
      );
    }),
  );
}

// MENU
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

// NAVIGATION
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

Future<void> showAppDialog(
  BuildContext context, {
  required String title,
  required String content,
  required void Function()? onPressed,
  String confirmText = "OK",
}) {
  return showDialog<void>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed:
                  onPressed ??
                  () {
                    Navigator.of(context).pop();
                  },
              child: Text(confirmText),
            ),
          ],
        ),
  );
}

Text text(
  String text,
  double fontSize,
  FontWeight fontWeight,
  Color color, [
  bool isOverflow = false,
  TextAlign align = TextAlign.center,
]) {
  return Text(
    text,
    textAlign: align,
    style: TextStyle(
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontFamily: "Gilroy",
      overflow: isOverflow ? TextOverflow.ellipsis : null,
    ),
  );
}
