// ignore_for_file: public_member_api_docs, sort_constructors_first

import "dart:io";

import "package:animations/animations.dart";
import "package:flutter/material.dart";

import "package:music_project/constants.dart";
import "package:music_project/widgets.dart";

class AudioPlayerScreen extends StatefulWidget {
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
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool isLiked = false;
  bool isVolume = false;
  bool isRepeat = false;
  bool isShuffle = false;
  bool isImageLoaded = false;
  String startTime = "00:00";
  String endTime = "1:00";
  double sliderValue = 0;
  @override
  void initState() {
    super.initState();
    _imageLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorAudioPlayer,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
          color: kAppBarTitleColorAudioPlayer,
        ),
        backgroundColor: kBackgroundColorAudioPlayer,
        centerTitle: true,

        title: text(
          "Playing now",
          20,
          FontWeight.bold,
          kAppBarTitleColorAudioPlayer,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              isImageLoaded
                  ? Image.file(
                    File(widget.imagePath!),
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  )
                  : Container(
                    color: const Color.fromARGB(60, 255, 255, 255),
                    width: 300,
                    height: 300,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const Icon(
                        Icons.music_note,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),

              const SizedBox(height: 28),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.center,
                      child: text(
                        "${widget.title}",
                        24,
                        FontWeight.bold,
                        kWhiteColorAudioPlayer,
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: _likeAnimation(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              text(
                "${widget.artist}",
                24,
                FontWeight.normal,
                Color(0xFFA5C0FF),
              ),
              const SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _iconAnimation(
                    Icons.volume_down_alt,
                    Icons.volume_up,
                    isVolume,
                    () {
                      setState(() {
                        isVolume = !isVolume;
                      });
                    },
                    kIconColorAudioPlayer,
                  ),
                  Row(
                    children: [
                      _iconAnimation(
                        Icons.repeat,
                        Icons.repeat_one,
                        isRepeat,
                        () {
                          setState(() {
                            isRepeat = !isRepeat;
                          });
                        },
                        kIconColorAudioPlayer,
                      ),
                      const SizedBox(width: 15),
                      _iconAnimation(
                        Icons.shuffle,
                        Icons.shuffle,
                        isShuffle,
                        () {
                          setState(() {
                            isShuffle = !isShuffle;
                          });
                        },
                        Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(startTime, 14, FontWeight.normal, kIconColorAudioPlayer),
                  text(endTime, 14, FontWeight.normal, kIconColorAudioPlayer),
                ],
              ),
              const SizedBox(height: 15),

              Slider(
                value: sliderValue,
                min: 0,
                max: 60,
                onChanged: (value) {
                  setState(() {
                    sliderValue = value;
                  });
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      color: kWhiteColorAudioPlayer,
                      size: 60,
                    ),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.pause,
                      color: kWhiteColorAudioPlayer,
                      size: 60,
                    ),
                  ),
                  const SizedBox(width: 15),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.skip_next_rounded,
                      color: kWhiteColorAudioPlayer,
                      size: 60,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector _likeAnimation() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLiked = !isLiked;
        });
      },
      child: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 400),
        reverse: !isLiked,
        transitionBuilder: (
          Widget child,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeScaleTransition(animation: animation, child: child);
        },
        child: Icon(
          isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey<bool>(isLiked),
          color: isLiked ? Colors.red : kIconColorAudioPlayer,
          size: 30,
        ),
      ),
    );
  }

  GestureDetector _iconAnimation(
    IconData icon1,
    IconData icon2,
    bool isAnimation,
    void Function() onTap,
    Color? color,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Icon(
          isAnimation ? icon2 : icon1,
          color: isAnimation ? color : kIconColorAudioPlayer,
          key: ValueKey<bool>(isAnimation),
          size: 30,
        ),
      ),
    );
  }

  void _imageLoaded() {
    if (widget.imagePath == null || widget.imagePath!.isEmpty) {
      return;
    } else if (!File(widget.imagePath!).existsSync()) {
      return;
    }
    setState(() {
      isImageLoaded = true;
    });
  }
}
