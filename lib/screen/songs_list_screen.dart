import 'package:flutter/material.dart';
import 'package:music_project/constants.dart';
import 'package:music_project/models/song.dart';
import 'package:music_project/widgets.dart';

class SongsListScreen extends StatelessWidget {
  final List<Song> songs;
  const SongsListScreen({super.key, required this.songs});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColorHomeScreen,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            backgroundColor: const Color.fromARGB(255, 19, 22, 42),
            pinned: true,
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
                        'В случайном порядке',
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
          buildMusicCard(songs),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: SizedBox(
        height: 48,
        child: TextFormField(
          decoration: InputDecoration(
            hintText: 'Искать',
            hintStyle: TextStyle(fontFamily: "Gilroy"),
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
}
