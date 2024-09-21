import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

class audiorecord extends StatefulWidget {
  const audiorecord({super.key});

  @override
  State<audiorecord> createState() => _audiorecordState();
}

class _audiorecordState extends State<audiorecord> {
  FlutterSoundRecorder? _recorder;
  bool isRecording = false;

  Future<void> startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      _recorder = FlutterSoundRecorder();

      await _recorder!.openRecorder();
      await _recorder!.startRecorder(
        toFile: 'audio_example.aac',
        codec: Codec.aacADTS,
      );

      setState(() {
        isRecording = true;
      });
    } else {
      print('Mikrofon izni verilmedi.');
    }
  }

  Future<void> stopRecording() async {
    await _recorder!.stopRecorder();
    await _recorder!.closeRecorder();
    _recorder = null;

    setState(() {
      isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ses Çalma ve Kaydetme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (isRecording) {
                  stopRecording();
                } else {
                  startRecording();
                }
              },
              child: Text(isRecording ? 'Kaydı Durdur' : 'Mikrofonla Kaydet'),
            ),
          ],
        ),
      ),
    );
  }
}
