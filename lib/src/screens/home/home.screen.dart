import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';

class HomeScreen extends StatelessWidget {
  static const String route = '/home';
  static const String path = "/home";
  static const String name = "Home Screen";

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              WaitingDialog.show(context, future: AuthController.I.logout());
            },
            child: const Text("Sign out"),
          ),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [Expanded(child: ImageUploadWidget())],
          ),
        ),
      ),
    );
  }
}

class ImageUploadWidget extends StatefulWidget {
  const ImageUploadWidget({super.key});

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  String? imageUrl;

  Uint8List? buffer;

  handleUploadRequest() async {
    Uint8List data = await selectAndCropImage();
    String url = await uploadFile(data);
    print(url);
    setState(() {
      imageUrl = url;
    });
  }

  Future<String> uploadFile(Uint8List data) async {
    Reference initialRef = FirebaseStorage.instance.ref();
    Reference finalPath = initialRef
        .child("images/${DateTime.now().toUtc().millisecondsSinceEpoch}.png");
    UploadTask uTask = finalPath.putData(data);
    uTask.snapshotEvents.listen((data) {
      print("${data.bytesTransferred / data.totalBytes}");
    });
    return uTask.then((data) => data.ref.getDownloadURL());
  }

  Future<Uint8List> selectAndCropImage() async {
    final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
    if (image == null) {
      throw Exception("Image selection/crop has been cancelled.");
    }
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      compressFormat: ImageCompressFormat.png,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Colors.amber,
          lockAspectRatio: true,
        ),
        // IOSUiSettings(
        //     title: 'Crop image',
        //     aspectRatioLockEnabled: true,
        //     aspectRatioLockDimensionSwapEnabled: true,
        //     aspectRatioPickerButtonHidden: false,
        //     rotateClockwiseButtonHidden: true),
      ],
    );
    if (croppedFile == null) {
      throw Exception("Image selection/crop has been cancelled.");
    }
    Uint8List resultImage = await croppedFile.readAsBytes();
    return resultImage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Builder(builder: (context) {
        // if (buffer != null) {
        //   return Center(
        //     child: AspectRatio(
        //       aspectRatio: 1,
        //       child: GestureDetector(
        //         onTap: () {},
        //         child: Image.memory(buffer!),
        //       ),
        //     ),
        //   );
        // }
        if (imageUrl != null) {
          return Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: GestureDetector(
                onTap: () {
                  WaitingDialog.show(context, future: handleUploadRequest());
                },
                child: Image.network(imageUrl!),
              ),
            ),
          );
        }
        return Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: GestureDetector(
              onTap: () {
                WaitingDialog.show(context, future: handleUploadRequest());
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black87),
                ),
                child: const Icon(
                  Icons.photo,
                  size: 64,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
