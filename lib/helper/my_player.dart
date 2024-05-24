import 'dart:io';

import 'package:app/helper/colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class MyPlayer extends StatefulWidget {
  const MyPlayer({super.key, required this.path, this.audio = false});
  final String path;
  final bool audio;

  @override
  State<MyPlayer> createState() => _MyPlayerState();
}

class _MyPlayerState extends State<MyPlayer> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  String? errorTitle, errorMessage;
  final _loading = true.obs,
      _playing = true.obs,
      _position = Duration.zero.obs,
      _showControls = true.obs;

  @override
  void initState() {
    _loading.value = true;
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.path))
      ..initialize().then((value) {
        _chewieController = ChewieController(
          videoPlayerController: _controller,
          autoPlay: true,
          looping: false,
        );
        _loading.value = false;
      }).catchError((error) {
        errorTitle = 'Error';
        if (error is SocketException) {
          errorMessage = 'Network error: Could not connect to the internet.';
        } else if (error is HttpException) {
          errorMessage =
              'HTTP error: The requested URL was not found on the server.';
        } else if (error is PlatformException) {
          errorTitle = 'Media Selected';
          errorMessage =
              'Media file selected, but preview is unavailable due to platform constraints.';
        } else {
          errorMessage = 'An unexpected error occurred: $error';
        }
        _loading.value = false;
      })
      ..addListener(() {
        _position.value = _controller.value.position;
        _playing.value = _controller.value.isPlaying;
      })
      ..setLooping(false)
      ..play();
    super.initState();
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
      _chewieController.dispose();
    } catch (e) {
      print(e.toString());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Obx(() => (_loading.value || errorMessage != null)
            ? ColoredBox(
                color: Colors.black,
                child: Center(
                  child: errorMessage != null
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                errorTitle ?? '',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: MyColorHelper.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 12.0),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: MyColorHelper.white),
                              ),
                            ],
                          ),
                        )
                      : CircularProgressIndicator(
                          color: MyColorHelper.red1,
                        ),
                ),
              )
            : widget.audio
                ? Stack(
                    children: [
                      InkWell(
                        onTap: () => _showControls.value = !_showControls.value,
                        child: _playing.value
                            ? ColoredBox(
                                color: Colors.black,
                                child: Opacity(
                                  opacity: 0.50,
                                  child: Image.asset(
                                    'assets/gifs/audio.gif',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : Image.asset(
                                'assets/images/audio_banner.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                      if (_showControls.value) ...[
                        Center(
                          child: IconButton(
                            onPressed: () => _playing.value
                                ? _controller.pause()
                                : _controller.play(),
                            icon: Icon(
                                _playing.value
                                    ? Icons.pause_circle_outline_rounded
                                    : Icons.play_circle_outline_rounded,
                                color: Colors.white.withOpacity(0.75),
                                size: 75),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _getDuration(_controller.value.duration),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      ' / ${_getDuration(_position.value)}',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                              VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: EdgeInsets.all(8.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  )
                : Chewie(controller: _chewieController)),
      ),
    );
  }

  String _getDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return duration.inHours == 0
        ? "$twoDigitMinutes:$twoDigitSeconds"
        : "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
