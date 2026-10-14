import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class BaiTap06 extends StatefulWidget {
  const BaiTap06({super.key});

  @override
  State<BaiTap06> createState() => _BaiTap06State();
}

class _BaiTap06State extends State<BaiTap06> {
  final AudioPlayer _player = AudioPlayer();
  final Random _random = Random();

  int _currentSongIndex = 0;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool _isPlaying = false;
  bool _isFavorite = false;
  bool _isShuffle = false;
  bool _isRepeat = false;

  final List<Map<String, String>> _songs = [
    {
      'title': 'Aria Math',
      'artist': 'C418',
      'audio': 'audio/Aria Math - C418.mp3',
      'image': 'assets/images/Aria Math - C418.jpg',
    },
    {
      'title': 'Chìm Sâu',
      'artist': 'RPT MCK (feat. Trung Trần)',
      'audio': 'audio/Chìm Sâu - RPT MCK (feat. Trung Trần).mp3',
      'image': 'assets/images/Chìm Sâu - RPT MCK (feat. Trung Trần).jpg',
    },
    {
      'title': 'Dancin',
      'artist': 'Aaron Smith (KRONO Remix)',
      'audio': 'audio/Dancin - Aaron Smith (KRONO Remix).mp3',
      'image': 'assets/images/Dancin - Aaron Smith (KRONO Remix).jpg',
    },
    {
      'title': 'Mơ',
      'artist': 'Vũ Cát Tường',
      'audio': 'audio/Mơ - Vũ Cát Tường.mp3',
      'image': 'assets/images/Mơ - Vũ Cát Tường.jpg',
    },
    {
      'title': 'Thằng điên',
      'artist': 'JUSTATEE x PHƯƠNG LY',
      'audio': 'audio/Thằng điên - JUSTATEE x PHƯƠNG LY.mp3',
      'image': 'assets/images/Thằng điên - JUSTATEE x PHƯƠNG LY.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();

    // Cập nhật vị trí hiện tại của bài hát.
    _player.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _position = position;
      });
    });

    // Lấy tổng thời lượng thật của file nhạc.
    _player.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        _duration = duration;
      });
    });

    // Theo dõi Play / Pause / Stop.
    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    // Khi bài hát kết thúc.
    _player.onPlayerComplete.listen((event) async {
      if (_isRepeat) {
        await _playCurrentSong();
      } else {
        await _nextSong();
      }
    });
  }

  // =========================================================
  // PLAY
  // =========================================================

  Future<void> _playCurrentSong() async {
    final String path = _songs[_currentSongIndex]['audio']!;

    await _player.stop();

    setState(() {
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    await _player.play(
      AssetSource(path),
    );
  }

  // =========================================================
  // PLAY / PAUSE
  // =========================================================

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _player.pause();
      return;
    }

    // Nếu bài đã được load và đang pause thì resume.
    if (_position > Duration.zero &&
        _position < _duration) {
      await _player.resume();
      return;
    }

    // Chưa phát bài nào hoặc bài đã kết thúc.
    await _playCurrentSong();
  }

  // =========================================================
  // NEXT
  // =========================================================

  Future<void> _nextSong() async {
    if (_isShuffle && _songs.length > 1) {
      int newIndex;

      do {
        newIndex = _random.nextInt(_songs.length);
      } while (newIndex == _currentSongIndex);

      _currentSongIndex = newIndex;
    } else {
      _currentSongIndex =
          (_currentSongIndex + 1) % _songs.length;
    }

    setState(() {
      _isFavorite = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    await _playCurrentSong();
  }

  // =========================================================
  // PREVIOUS
  // =========================================================

  Future<void> _previousSong() async {
    // Nếu đã nghe quá 3 giây thì quay về đầu bài.
    if (_position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }

    if (_isShuffle && _songs.length > 1) {
      int newIndex;

      do {
        newIndex = _random.nextInt(_songs.length);
      } while (newIndex == _currentSongIndex);

      _currentSongIndex = newIndex;
    } else {
      _currentSongIndex--;

      if (_currentSongIndex < 0) {
        _currentSongIndex = _songs.length - 1;
      }
    }

    setState(() {
      _isFavorite = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    await _playCurrentSong();
  }

  // =========================================================
  // SEEK
  // =========================================================

  Future<void> _seek(double value) async {
    await _player.seek(
      Duration(milliseconds: value.toInt()),
    );
  }

  // =========================================================
  // SHUFFLE
  // =========================================================

  void _toggleShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
  }

  // =========================================================
  // REPEAT
  // =========================================================

  void _toggleRepeat() {
    setState(() {
      _isRepeat = !_isRepeat;
    });
  }

  // =========================================================
  // FAVORITE
  // =========================================================

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  // =========================================================
  // FORMAT 0:00
  // =========================================================

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);

    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // =========================================================
  // UI
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final song = _songs[_currentSongIndex];

    final double maxDuration =
        _duration.inMilliseconds > 0
            ? _duration.inMilliseconds.toDouble()
            : 1;

    final double currentPosition =
        _position.inMilliseconds
            .clamp(
              0,
              maxDuration.toInt(),
            )
            .toDouble();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 15,
          ),
          child: Column(
            children: [
              // ================= HEADER =================

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _squareButton(
                    icon: Icons.arrow_back,
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                  ),

                  const Text(
                    'P L A Y L I S T',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),

                  _squareButton(
                    icon: Icons.menu,
                    onPressed: () {
                      _showPlaylist();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ================= ALBUM CARD =================

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius:
                              BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(
                                alpha: 0.35,
                              ),
                              blurRadius: 10,
                              offset: const Offset(5, 5),
                            ),
                            const BoxShadow(
                              color: Colors.white,
                              blurRadius: 10,
                              offset: Offset(-5, -5),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(8),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: Image.asset(
                                  song['image']!,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        song['artist']!,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              FontWeight.w500,
                                        ),
                                      ),

                                      const SizedBox(height: 4),

                                      Text(
                                        song['title']!,
                                        maxLines: 1,
                                        overflow:
                                            TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 23,
                                          fontWeight:
                                              FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                IconButton(
                                  onPressed: _toggleFavorite,
                                  icon: Icon(
                                    _isFavorite
                                        ? Icons.favorite
                                        : Icons
                                            .favorite_border,
                                    color: _isFavorite
                                        ? Colors.red
                                        : Colors.grey,
                                    size: 32,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // ================= TIMER =================

                      Row(
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          IconButton(
                            tooltip: 'Shuffle',
                            onPressed: _toggleShuffle,
                            icon: Icon(
                              Icons.shuffle,
                              color: _isShuffle
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),

                          const SizedBox(width: 15),

                          IconButton(
                            tooltip: 'Repeat',
                            onPressed: _toggleRepeat,
                            icon: Icon(
                              Icons.repeat_one,
                              color: _isRepeat
                                  ? Colors.green
                                  : Colors.black,
                            ),
                          ),

                          const Spacer(),

                          Text(
                            _formatDuration(_duration),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // ================= SLIDER =================

                      Slider(
                        min: 0,
                        max: maxDuration,
                        value: currentPosition,
                        activeColor: Colors.green,
                        inactiveColor: Colors.grey[300],
                        onChanged: _duration > Duration.zero
                            ? _seek
                            : null,
                      ),

                      const SizedBox(height: 15),

                      // ================= CONTROLS =================

                      Row(
                        children: [
                          Expanded(
                            child: _controlButton(
                              icon: Icons.skip_previous,
                              onPressed: _previousSong,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            flex: 2,
                            child: _controlButton(
                              icon: _isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              iconSize: 40,
                              onPressed: _playPause,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: _controlButton(
                              icon: Icons.skip_next,
                              onPressed: _nextSong,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PLAYLIST
  // =========================================================

  void _showPlaylist() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _songs.length,
          itemBuilder: (context, index) {
            final song = _songs[index];

            return ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  song['image']!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),

              title: Text(
                song['title']!,
                style: TextStyle(
                  fontWeight:
                      index == _currentSongIndex
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),

              subtitle: Text(song['artist']!),

              trailing:
                  index == _currentSongIndex
                      ? const Icon(
                          Icons.equalizer,
                          color: Colors.green,
                        )
                      : null,

              onTap: () async {
                Navigator.pop(context);

                setState(() {
                  _currentSongIndex = index;
                  _isFavorite = false;
                  _position = Duration.zero;
                  _duration = Duration.zero;
                });

                await _playCurrentSong();
              },
            );
          },
        );
      },
    );
  }

  // =========================================================
  // SMALL BUTTON
  // =========================================================

  Widget _squareButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 55,
      height: 55,
      decoration: _buttonDecoration(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }

  // =========================================================
  // PLAYER BUTTON
  // =========================================================

  Widget _controlButton({
    required IconData icon,
    required VoidCallback onPressed,
    double iconSize = 30,
  }) {
    return Container(
      height: 80,
      decoration: _buttonDecoration(),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: iconSize,
        ),
      ),
    );
  }

  BoxDecoration _buttonDecoration() {
    return BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.35),
          blurRadius: 8,
          offset: const Offset(4, 4),
        ),
        const BoxShadow(
          color: Colors.white,
          blurRadius: 8,
          offset: Offset(-4, -4),
        ),
      ],
    );
  }
}