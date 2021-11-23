import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future<void> requestCameraPermission() async {

    final serviceStatus = await Permission.storage.isGranted ;

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

  http35() async{
   var response = await http.get(Uri.parse('https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3'));
  print(response.bodyBytes);
  }
  write()async{
    var response = await http.get(Uri.parse('https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3'));
    //print(response.bodyBytes);
    Directory? tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir!.path;
    //File file=File('$tempPath/deneme1.mp3');
    String path35='/storage/emulated/0/Download';
    File file=File('$path35/deneme8.mp3');
   await file.writeAsBytes(response.bodyBytes);
    print('Dosya kaydedildi.');
  }

  path()async{
    Directory? tempDir = await getExternalStorageDirectory();
    String tempPath = tempDir!.path;
    print(tempPath);
    var temDirParent=tempDir.parent;
    var temDirParent1=temDirParent.parent;
    print(temDirParent1);
    var temDirParent2=temDirParent1.parent;
    print(temDirParent2);
    var temDirParent3=temDirParent2.parent;
    print(temDirParent3);
    List<FileSystemEntity> listDir=temDirParent2.listSync();
   /* listDir.forEach((element) {
      print(element);
    })*/;
  }

  String title='Audio Player';
  AudioPlayer audioPlayer = AudioPlayer();

  play() async {
    int result = await audioPlayer.play('https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3');
    if (result == 1) {
      // success
    }
  }

  playLocal() async {
    //Directory? tempDir = await getExternalStorageDirectory();
    //String tempPath = tempDir!.path;
   //String localPath='$tempPath/deneme1.mp3';
    String localPath='/storage/emulated/0/Download/deneme5.mp3';
   // File file=File('$tempPath/deneme1.mp3');
    int result = await audioPlayer.play(localPath, isLocal: true);
  }

  @override
  void initState() {
    super.initState();
    requestCameraPermission();
    //path();
    //http35();
    playLocal();
    //write();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'player',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Audio Players'),
              ElevatedButton(
                  onPressed: (){
                    play();
                    setState(() {
                      title='Play';
                    });
                    print('Play');
                  },
                  child: Text('Play')
              ),
              ElevatedButton(
                  onPressed: () async{
                    int result = await audioPlayer.pause();
                    setState(() {
                      title='Pause';
                    });
                    print('Pause');
                  },
                  child: Text('Pause')
              ),
              ElevatedButton(
                  onPressed: () async{
                    int result = await audioPlayer.stop();
                    setState(() {
                      title='Stop';
                    });
                    print('Stop');
                  },
                  child: Text('Stop')
              ),
            ],
          ),
        ),
      ),
    );
  }
}
