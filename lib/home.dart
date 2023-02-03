import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  final imagePicker = ImagePicker();
  List processedImage = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _load_model();
  }

  _load_model() async {
    await Tflite.loadModel(
        model: 'assets/hand_landmark_full.tflite', labels: "");
  }

  _loadImage_gallery() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _image = File(image.path);
      setState(() {
        _loading = false;
      });
    }
    _detect_image(_image);
  }

  _loadImage_camera() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      _image = File(image.path);
      setState(() {
        _loading = false;
      });
    }
    _detect_image(_image);
  }

  _detect_image(File image) async {
    // await Tflite.detectObjectOnFrame(bytesList: image.planes.map((plane) {
    //   return plane.bytes;
    // }).toList(),
    // numResultsPerClass: 63;
    // );
    var _processedImage = await Tflite.runModelOnImage(path: image.path);
    setState(() {
      _loading = false;
      processedImage = _processedImage!;
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Hand detector"),
      ),
      body: Container(
        height: h,
        width: w,
        child: Column(
          children: [
            Container(
              child: Text(
                "Hand gesture detector",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: ElevatedButton(
                onPressed: _loadImage_camera,
                child: Text("Camera"),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: ElevatedButton(
                onPressed: _loadImage_gallery,
                child: Text("Gallery"),
              ),
            ),
            _loading == false
                ? Column(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: Image.file(_image),
                      ),
                      Text(processedImage[0].toString()),
                    ],
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
