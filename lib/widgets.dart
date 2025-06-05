import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_project/screen/audio_player_screen.dart';
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
      debugPrint("${song.id}");
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
          text3: 'Удалить',
          onTap1: () {},
          onTap2: () {},
          onTap3: () {
            showAppDialog(
              context,
              title: "Удалить песню",
              content: "Вы уверены, что хотите удалить эту песню?",
              onPressed: () async {
                try {
                  File file = File(song.path);
                  if (file.existsSync()) {
                    await file.delete();
                    scaffoldMessenger(context, "Песня удалена");
                  }
                  else {
                    debugPrint("Файл не найден: ${song.path}");
                  }
                } catch (e) {
                    debugPrint("Файл не найден: ${song.path}");
                  debugPrint("Ошибка при удалении песни: $e");
                  scaffoldMessenger(context, "Ошибка при удалении песни");
                } finally {
                  Navigator.of(context).pop();
                }
              },
            );
          },
        ),
      );
    }),
  );
}

// MENU
PopupMenuButton showSongMenu(
  BuildContext context, {
  required String text1,
  required String text2,
  required String text3,
  required void Function() onTap1,
  required void Function() onTap2,
  required void Function() onTap3,
}) {
  return PopupMenuButton(
    itemBuilder: (context) {
      return [
        PopupMenuItem(value: 0, onTap: onTap1, child: Text(text1)),
        PopupMenuItem(value: 1, onTap: onTap2, child: Text(text2)),
        PopupMenuItem(value: 2, onTap: onTap3, child: Text(text3)),
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
