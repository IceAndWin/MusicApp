import "package:flutter/material.dart";
import "package:music_project/consts.dart";

class AudioPlayerScreen extends StatelessWidget {
  final String? title;
  final String? artist;
  final String? imagePath;
  final int? songId;
  const AudioPlayerScreen({
    super.key,
    required this.title,
    required this.artist,  
    required this.imagePath,
    required this.songId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorAudioPlayer,
      appBar: AppBar(
        backgroundColor: kBackgroundColorAudioPlayer,
        centerTitle: true,
        title: Text(
          "Playing now",
          style: TextStyle(color: kAppBarTitleColorAudioPlayer),
        ),
      ),
      body: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Image.asset(
            imagePath ?? "assets/cards/music_card.png",
            height: 300,
            width: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          
        ],
      ),
    );
  }
}
