import 'dart:convert';

import 'package:http_parser/http_parser.dart';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../main.dart';

class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  Future<String> takePicture() async {
    try {
      final image = await controller.takePicture();
      print(image.path);
      return image.path;
    } catch (e) {
      print(e);
      return '';
    }
  }

  Future<String> postImage(String imagePath, String ip) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("http://$ip:5000/"),
    );
    final file = File(imagePath);
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: 'filename.jpg',
        contentType: MediaType('image', 'jpeg'),
      ),
    );
    request.headers.addAll(headers);

    final response = await request.send();
    String data = await response.stream.bytesToString();
    print(data);
    return data;

    // final file = File(imagePath).readAsBytesSync();
    // final request =
    //     http.MultipartRequest('Post', Uri.parse('http://$ip:5000/'));
    // final httpImage = http.MultipartFile.fromBytes('files.myimage', file,
    //     filename: 'myImage.png');

    // request.files.add(httpImage);

    // final response = await request.send();

    // return response.statusCode.toString();

    // final response = await http.post(
    //   Uri.parse('http://$ip:5000/'),
    //   headers: {"Content-Type": "multipart/form-data"},
    //   body: {'file': base64Encode(file)},
    //   encoding: Encoding.getByName('utf-8'),
    // );
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[1], ResolutionPreset.ultraHigh);
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
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          clipBehavior: Clip.antiAlias,
          child: CameraPreview(controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () async {
          final imagePath = await takePicture();

          final value = await postImage(imagePath, '192.168.1.14');

          final data = jsonDecode(value);

          final Map<String, dynamic> extractedData = data['extracted_data'];
          final Map<String, dynamic> healthEvaluation =
              data['health_evaluation'];

          print(extractedData);

          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return AlertDialog(
          //       title: const Text('Image Captured'),
          //       content: Image.file(File(imagePath)),
          //       actions: [
          //         TextButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           child: const Text('Close'),
          //         ),
          //       ],
          //     );
          //   },
          // );
          if (!context.mounted) return;
          showModalBottomSheet(
            useSafeArea: true,
            isScrollControlled: true,
            showDragHandle: true,
            context: context,
            builder: (context) => DraggableScrollableSheet(
              expand: false,
              snap: true,
              shouldCloseOnMinExtent: false,
              builder: (context, scrollController) => ListView(
                controller: scrollController,
                children: [
                  const Text('Extracted Data'),
                  for (var key in extractedData.keys)
                    ListTile(
                      title: Text(key),
                      subtitle: Text(extractedData[key]),
                    ),
                  const Text('Health Evaluation'),
                  for (var key in healthEvaluation.keys)
                    ListTile(
                      title: Text(key),
                      subtitle: Text(healthEvaluation[key]),
                    ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.camera),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
    //   if (!controller.value.isInitialized) {
    //     return Container();
    //   }
    //   return ;
  }
}
