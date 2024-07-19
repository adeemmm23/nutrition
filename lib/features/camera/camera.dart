import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:camera/camera.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:nutrution/components/rounded_appbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import 'components/bottom_sheet.dart';

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  Future<String> takePicture() async {
    try {
      final image = await controller.takePicture();
      return image.path;
    } catch (e) {
      return '';
    }
  }

  Future<String> postImage(String path, String ip) async {
    final file = File(path);
    final headers = {"Content-type": "multipart/form-data"};
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("http://$ip:5000/"),
    );

    request.headers.addAll(headers);
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: 'scanned.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    try {
      final response = await request.send();
      file.delete();

      if (response.statusCode != 200) return 'wrong';
      final data = await response.stream.bytesToString();
      print(data);
      return data;
    } on Exception catch (_) {
      return 'error';
    }
  }

  void handleCamera() async {
    final imagePath = await takePicture();
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString('ip') ?? '';
    if (ip.isEmpty) return;

    print(ip);
    final value = await postImage(imagePath, ip);

    if (value == 'error') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to connect to server'),
        ),
      );
      return;
    }

    if (value == 'wrong') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to scan image'),
        ),
      );
      return;
    }

    final Map<String, dynamic> data = jsonDecode(value);
    final Map<String, dynamic> extractedData = data['extracted_data'];
    final Map<String, dynamic> healthEvaluation = data['health_evaluation'];

    final junk = prefs.getString('history') ?? "[]";
    final List history = jsonDecode(junk);

    history.add({
      'date': DateTime.now().toString(),
      'data': extractedData,
      'health': healthEvaluation,
    });

    prefs.setString('history', jsonEncode(history));

    if (!mounted) return;
    handleBottomSheet(context, extractedData, healthEvaluation);
  }

  void handleBottomSheet(
    BuildContext context,
    Map<String, dynamic> extractedData,
    Map<String, dynamic> healthEvaluation,
  ) {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      context: context,
      builder: (context) => DataBottomSheet(extractedData, healthEvaluation),
    );
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: RoundedAppBar(title: 'Scan'),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(
                  top: 10, bottom: 30, right: 20, left: 20),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              clipBehavior: Clip.antiAlias,
              child: CameraPreview(controller),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: IconButton.filled(
                iconSize: 40,
                onPressed: handleCamera,
                icon: const Icon(Symbols.circle_rounded),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   elevation: 0,
      //   onPressed: handleCamera,
      //   child: const Icon(Icons.camera),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
    //   if (!controller.value.isInitialized) {
    //     return Container();
    //   }
    //   return ;
  }
}
