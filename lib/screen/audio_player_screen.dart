// ignore_for_file: public_member_api_docs, sort_constructors_first

import "dart:io";

import "package:animations/animations.dart";
import "package:flutter/material.dart";

import "package:music_project/constants.dart";
import "package:music_project/models/favorite_manager.dart";
import "package:music_project/models/song.dart";
import "package:music_project/widgets.dart";
import "package:audioplayers/audioplayers.dart";
import "package:provider/provider.dart";

class AudioPlayerScreen extends StatefulWidget {
  final String? title;
  final String? artist;
  final String? imagePath;
  final int? songId;
  final String path;
  const AudioPlayerScreen({
    super.key,
    required this.title,
    required this.artist,
    required this.imagePath,
    required this.songId,
    required this.path,
  });

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  bool isLiked = false;
  bool isVolume = true;
  bool isRepeat = false;
  bool isShuffle = false;
  bool isImageLoaded = false;

  String? _durationText;
  String? _positionText;

  bool isPlaying = false;

  final AudioPlayer audioPlayer = AudioPlayer();

  Duration? _duration;
  Duration? _position;

  late Song song;
  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _imageLoaded();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => song)
      ],
      child: Scaffold(
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
                          audioPlayer.setVolume(isVolume ? 1.0 : 0.0);
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
                              audioPlayer.setReleaseMode(
                                isRepeat ? ReleaseMode.loop : ReleaseMode.stop,
                              );
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
                    text(
                      _positionText ?? "00:00",
                      14,
                      FontWeight.normal,
                      kIconColorAudioPlayer,
                    ),
                    text(
                      _durationText ?? "00:00",
                      14,
                      FontWeight.normal,
                      kIconColorAudioPlayer,
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                Slider(
                  activeColor: Colors.blue,
                  inactiveColor: Colors.grey,
                  value: (_position?.inMilliseconds ?? 0).toDouble(),

                  min: 0,
                  max: (_duration?.inMilliseconds ?? 1).toDouble(),
                  onChanged: (value) {
                    final duration = _duration;
                    if (duration == null) {
                      return;
                    }
                    final newPosition = Duration(milliseconds: value.toInt());
                    audioPlayer.seek(newPosition);
                    setState(() {
                      _position = newPosition;
                      _positionText =
                          "${_position!.inMinutes}:${(_position!.inSeconds % 60).toString().padLeft(2, '0')}";
                    });
                  },
                ),
                const SizedBox(height: 80),
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
                      onPressed: () async {
                        await audioPlayer.play(UrlSource(widget.path));
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                        if (isPlaying) {
                          _resume();
                        } else {
                          _pause();
                        }
                      },
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled_rounded
                            : Icons.play_circle_filled_rounded,
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
      ),
    );
  }

  Future<void> _initAudioPlayer() async {
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
        _durationText =
            "${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
      });
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
        _positionText =
            "${position.inMinutes}:${(position.inSeconds % 60).toString().padLeft(2, '0')}";
      });
    });

    await audioPlayer.setSourceUrl(widget.path);

    song = Song(
      title: widget.title!,
      artist: widget.artist!,
      imagePath: widget.imagePath,
      id: widget.songId!,
      path: widget.path,
    );
  }

  Future<void> _resume() async {
    await audioPlayer.resume();
  }

  Future<void> _pause() async {
    await audioPlayer.pause();
  }

  GestureDetector _likeAnimation() {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLiked = !isLiked;
        });
        final favorites = await FavoriteManager.getFavorites();
        if (isLiked) {
          FavoriteManager.addFavorite(widget.songId!);
          scaffoldMessenger(context, "Добавлено в избранное");
        } else {
          if (favorites.contains(widget.songId)) {
            FavoriteManager.removeFavorite(widget.songId!);
            scaffoldMessenger(context, "Удалено из избранного");
          }
        }
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
