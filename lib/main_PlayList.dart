import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyApp1(),
    );
  }
}

class MyApp1 extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  String song = '';
  int count = 0;
  String zaman = '';
  String zamanText = 'Audio Player';
  int secondIndex = 0;
  String songTitle = 'songTitle';
  String title = 'Audio Player';
  AudioPlayer audioPlayer = AudioPlayer();

  play(int currentIndex) async {
    if (currentIndex < songPlayList.length) {
      Future.delayed(const Duration(milliseconds: 250), () async {
        String state = audioPlayer.state.toString();
        if (state == 'PlayerState.PAUSED' || state == 'PlayerState.STOPPED') {
          int result =
          await audioPlayer.play(songPlayList[currentIndex], isLocal: true);
          setState(() {
            songTitle = songPlayList[currentIndex]
                .split('/')
                .last;
            secondIndex = currentIndex;
          });
          audioPlayer.onPlayerCompletion.listen((event) async {
            print('audioPlayer.onPlayerCompletion');
            if (currentIndex <((songPlayList.length)-1)) {
              currentIndex++;
              await audioPlayer.play(songPlayList[currentIndex], isLocal: true);
              print(songPlayList[currentIndex]);
              setState(() {
                songTitle = songPlayList[currentIndex]
                    .split('/')
                    .last;
                secondIndex = currentIndex;
              });
              print('Completion secondIndex $secondIndex');
              print('Completion currentIndex $currentIndex');
            } else {
              print('Stop secondIndex $secondIndex');
              print('Stop currentIndex $currentIndex');
              await audioPlayer.stop();
              currentIndex=0;
              secondIndex=0;
              setState(() {
                songTitle = 'Playlist is finished';
              });
            }
          });
        }
      });
    }
  }

  List<String> songPlayList = [];

  playList() async {
    String playDir = '/storage/emulated/0/Music';
    Directory directoryPlay = Directory(playDir);
    List listPlayList = directoryPlay.listSync();
    listPlayList.forEach((element) {
      if (element is File) {
        songPlayList.add(element.path);
        print(element.path);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    playList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        title: Text(songTitle),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    secondIndex;
                    play(secondIndex);
                  });
                  print('Play');
                  print(secondIndex);
                },
                child: Text('Play')),
            ElevatedButton(
                onPressed: () async {
                  int result = await audioPlayer.pause();
                  print('Pause');
                },
                child: Text('Pause')),
            ElevatedButton(
                onPressed: () async {
                  int result = await audioPlayer.stop();
                  print('Stop');
                  setState(() {
                    secondIndex;
                    print(secondIndex);
                  });

                },
                child: Text('Stop')),
          ],
        ),
      ),
    );
  }
}
