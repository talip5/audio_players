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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String song = '';
  int count = 0;

  Future<void> requestCameraPermission() async {
    final serviceStatus = await Permission.storage.isGranted;

    bool isSorageOn = serviceStatus == ServiceStatus.enabled;

    final status = await Permission.storage.request();

    if (status == PermissionStatus.granted) {
      print('Permission Granted');
    } else if (status == PermissionStatus.denied) {
      print('Permission denied');
    } else if (status == PermissionStatus.permanentlyDenied) {
      print('Permission Permanently Denied');
      await openAppSettings();
    }
  }

  http35() async {
    var response = await http.get(Uri.parse(
        'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3'));
    print(response.bodyBytes);
  }

  write() async {
    var response = await http.get(Uri.parse(
        'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3'));
    //print(response.bodyBytes);
    Directory? tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir!.path;
    //File file=File('$tempPath/deneme1.mp3');
    String path35 = '/storage/emulated/0/Download';
    File file = File('$path35/deneme1.mp3');
    await file.writeAsBytes(response.bodyBytes);
    print('Dosya kaydedildi.');
  }

  path() async {
    Directory? tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir!.path;
    print(tempPath);
    var temDirParent = tempDir.parent;
    var temDirParent1 = temDirParent.parent;
    print(temDirParent1);
    var temDirParent2 = temDirParent1.parent;
    print(temDirParent2);
    var temDirParent3 = temDirParent2.parent;
    print(temDirParent3);
    List<FileSystemEntity> listDir = temDirParent2.listSync();
    /* listDir.forEach((element) {
      print(element);
    })*/
  }

  String title = 'Audio Player';
  AudioPlayer audioPlayer = AudioPlayer();

  play() async {
    Future.delayed(const Duration(milliseconds: 250), () async {
      String state = audioPlayer.state.toString();
      if (state == 'PlayerState.PAUSED' || state == 'PlayerState.STOPPED') {
        // await audioPlayer.play('https://firebasestorage.googleapis.com/v0/b/cloud2-f6bda.appspot.com/o/music%2Fa1.mp3?alt=media&token=437bc1e0-2447-4e11-ae38-5c6684ba090f');
        await audioPlayer.play(
            'https://firebasestorage.googleapis.com/v0/b/cloud2-f6bda.appspot.com/o/music%2Fa1.mp3?alt=media&token=437bc1e0-2447-4e11-ae38-5c6684ba090f');
        time();
      }
    });
  }

  time() async {
    //print('1');
    Future.delayed(const Duration(milliseconds: 250), () {
      // print('Hello, world');
      print(audioPlayer.state);
      setState(() {
        String state = audioPlayer.state.toString();
        if (state == 'PlayerState.PLAYING') {
          title = 'Playing';
        } else if (state == 'PlayerState.PAUSED') {
          title = 'Pause';
        } else if (state == 'PlayerState.STOPPED') {
          title = 'Stop';
        }
      });
    });
    //print('2');
  }


  deneme() async {
    /*print(PlayerMode.values);
    print(audioPlayer.mode);
    List<PlayerMode> list=[];
    print(list);
    var playerMode1=PlayerMode.MEDIA_PLAYER;
    list.add(playerMode1);
    print(list);*/
    //print(AudioPlayer.players.values.first.state);
    // print(PlayerState.values);
    print(audioPlayer.state);
  }

  playLocal() async {
    Directory? tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir!.path;
    //String localPath='$tempPath/deneme1.mp3';
    List<String> songList = [];
    List list = tempDir.listSync();
    print(list);
    list.forEach((element) {
      if (element is File) {
        songList.add(element.path);
      }
    });
    song = songList[count];
    print(song);
    //String localPath='/storage/emulated/0/Download/deneme1.mp3';
    //File file=File('$tempPath/deneme1.mp3');
    // int result = await audioPlayer.play(localPath, isLocal: true);
    int result = await audioPlayer.play(song, isLocal: true);
    //time();
  }

  position() async {
    audioPlayer.onAudioPositionChanged.listen((Duration p) =>
    { print('Current position: $p')
    });
  }

  @override
  void initState() {
    super.initState();
    //requestCameraPermission();
    //path();
    //http35();
    //playLocal();
    //write();
    //deneme();
    //time();
    position();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'player',
      home: Scaffold(
        //key: _scaffoldKey,
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(onPressed:(){
                final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Hello from ScaffoldMessenger')),
                );
              },
                  child: Text('SnackBar')),
              Text('Audio Players'),
              ElevatedButton(
                  onPressed: () {
                    playLocal();
                    //play();
                    //time();
                    print('Play');
                  },
                  child: Text('Play')
              ),
              ElevatedButton(
                  onPressed: () async {
                    int result = await audioPlayer.pause();
                    time();
                    print('Pause');
                  },
                  child: Text('Pause')
              ),
              ElevatedButton(
                  onPressed: () async {
                    int result = await audioPlayer.stop();
                    // time();
                    print('Stop');
                  },
                  child: Text('Stop')
              ),
            ],
          ),
        ),)
      ,
    );
  }
}
