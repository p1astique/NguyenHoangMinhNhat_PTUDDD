import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class VideoRecorderPlayback extends StatefulWidget {
  const VideoRecorderPlayback({super.key});

  @override
  State<VideoRecorderPlayback> createState() =>
      _VideoRecorderPlaybackState();
}

class _VideoRecorderPlaybackState
    extends State<VideoRecorderPlayback> {
  final ImagePicker _picker = ImagePicker();

  XFile? _videoFile;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();
  }

  Future<void> _pickVideo(ImageSource source) async {
    final XFile? video = await _picker.pickVideo(
      source: source,
    );

    if (video != null) {
      await _videoController?.dispose();

      _videoFile = video;

      _videoController = VideoPlayerController.file(
        File(video.path),
      );

      await _videoController!.initialize();

      setState(() {});
    }
  }

  void _playPauseVideo() {
    if (_videoController == null) {
      return;
    }

    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recorder & Playback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_videoFile != null &&
                _videoController != null &&
                _videoController!.value.isInitialized)
              AspectRatio(
                aspectRatio:
                    _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            else
              const SizedBox(
                height: 250,
                child: Center(
                  child: Text('Chưa có video'),
                ),
              ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                _pickVideo(ImageSource.camera);
              },
              child: const Text('Quay video từ Camera'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                _pickVideo(ImageSource.gallery);
              },
              child: const Text('Chọn video từ Gallery'),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _videoController == null
                  ? null
                  : _playPauseVideo,
              child: Text(
                _videoController?.value.isPlaying == true
                    ? 'Pause'
                    : 'Play',
              ),
            ),
          ],
        ),
      ),
    );
  }
}