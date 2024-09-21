import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guide_me/screens/PlacesDetail.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PlayerWidget extends StatefulWidget {
  final String img;
  final String name;
  final String audio;
  const PlayerWidget({
    super.key,
    required this.img,
    required this.name,
    required this.audio,
  });

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState();
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  AudioPlayer player = AudioPlayer();
  bool isPlaying = false;
  PlayerState? _playerState;
  Duration? _duration = Duration.zero;
  Duration? _position = Duration.zero;

  late StreamSubscription<PlayerState> _playerStateSubscription;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;

  @override
  void initState() {
    super.initState();
    _initStreams();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await player.setSource(UrlSource(widget.audio));
    });
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  void _initStreams() {
    _playerStateSubscription = player.onPlayerStateChanged.listen(
      (state) {
        setState(() {
          _playerState = state;
          isPlaying = state == PlayerState.playing;
        });
      },
    );

    _durationSubscription = player.onDurationChanged.listen(
      (duration) => setState(() => _duration = duration),
    );

    _positionSubscription = player.onPositionChanged.listen(
      (position) => setState(() => _position = position),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((_) {
      setState(() {
        _position = Duration.zero;
        isPlaying = false;
      });
    });
  }

  String formatDuration(Duration? duration) {
    if (duration == null) return '00:00';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PlacesDetail()),
            );
          },
          child: Container(
              height: 16.h,
              width: 100.w,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(200, 30, 129, 176), width: 2),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // Gölgenin konumu
                    ),
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 68,
                          height: 68,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage(widget.img),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Text(
                            widget.name,
                            style: GoogleFonts.inter(
                                fontWeight: FontWeight.w300, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 13.h,
                    width: 68.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: isPlaying ? _pause : _play,
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            color: const Color.fromARGB(200, 30, 129, 176),
                          ),
                          iconSize: 50,
                        ),
                        Column(
                          children: [
                            Slider(
                              activeColor:
                                  const Color.fromARGB(200, 30, 129, 176),
                              inactiveColor: Colors.grey[400],
                              onChanged: (value) {
                                if (_duration == null) return;
                                final position =
                                    value * _duration!.inMilliseconds;
                                player.seek(
                                    Duration(milliseconds: position.round()));
                              },
                              value: (_position != null &&
                                      _duration != null &&
                                      _position!.inMilliseconds > 0 &&
                                      _position!.inMilliseconds <
                                          _duration!.inMilliseconds)
                                  ? _position!.inMilliseconds /
                                      _duration!.inMilliseconds
                                  : 0.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 40.w,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(formatDuration(_position)),
                                    Text(formatDuration(_duration))
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )),
        ));
  }

  Future<void> _play() async {
    await player.resume();
    setState(() => isPlaying = true);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => isPlaying = false);
  }
}
