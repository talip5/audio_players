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
  String zaman='';
  String zamanText='Audio Player';

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
        'https://file-examples-com.github.io/uploads/2017/11/file_example_MP3_700KB.mp3'));
    //var response = await http.get(Uri.parse('https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3'));
    //print(response.bodyBytes);
    Directory? tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir!.path;
    //File file=File('$tempPath/deneme1.mp3');
    String path35 = '/storage/emulated/0/Download';
    File file = File('$path35/deneme0.mp3');
    await file.writeAsBytes(response.bodyBytes);
    print('Dosya kaydedildi.');
  }

  delete() async{
    String path35 = '/storage/emulated/0/Download';
    File file = File('$path35/deneme2.mp3');
    file.deleteSync();
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


  PlayerState? playerState;
  stateEvent() async{
    /* audioPlayer.onPlayerStateChanged.listen((PlayerState s) => {
    print('Current player state: $s');
        setState(()  playerState = s);
  });*/
    //audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      print('Current player state: $s');
      setState(() {
        playerState=s;
      });
    });
  }
  List<String> songPlayList=[];
  playList() async{
    String playDir='/storage/emulated/0/Download';
    Directory directoryPlay=Directory(playDir);
    print(directoryPlay);
    List listPlayList=directoryPlay.listSync();
    listPlayList.forEach((element) {
      if(element is File){
        songPlayList.add(element.path);
        print(element.path);
      }
    });
    print(songPlayList[8]);
    // int result = await audioPlayer.play(songPlayList[0], isLocal: true);
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
    // int result = await audioPlayer.play(song, isLocal: true);
    //time();
  }

  position() async {
    audioPlayer.onAudioPositionChanged.listen((Duration p) =>
    { print('Current position: $p')
    });
  }

  completionEvent() async{
    int result = await audioPlayer.play(songPlayList[8], isLocal: true);
    audioPlayer.onPlayerCompletion.listen((event) {
      print('completion');
      //   onComplete();
      //   setState(() {
      //     position = duration;
      //   });
      // });
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
    //position();
    //playList();
    //stateEvent();
    //completionEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed:(){
              audioPlayer.onAudioPositionChanged.listen((Duration p) =>
              { print('Current position: $p'),
                print(p.toString()),
                zaman=p.inMilliseconds.toString()
              });
              final ScaffoldMessengerState scaffoldMessenger = ScaffoldMessenger.of(context);
              setState(() {
                zamanText=zaman;
                scaffoldMessenger.showSnackBar(
                  SnackBar(content: Text('SnackBar $zaman'),
                    backgroundColor: Colors.lightGreen,
                    duration: Duration(seconds: 1),
                  ),
                );
              });
            },
                child: Text('SnackBar')),
            Text(zamanText),
            Text('Current player state: $playerState'),
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
      ),
    );
  }
}
