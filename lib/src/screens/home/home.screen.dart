import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:state_change_demo/src/controllers/auth_controller.dart';
import 'package:state_change_demo/src/controllers/user_data_controller.dart';
import 'package:state_change_demo/src/dialogs/waiting_dialog.dart';
import 'package:state_change_demo/src/services/firestore_service.dart';

import '../../models/user2.model.dart';

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
        title: const Text("Home"),
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
            children: [
              Center(
                child: UserProfileScreen(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? user;
  late UserDataController userDataController;
  @override
  void initState() {
    super.initState();
    userDataController = UserDataController();
    userDataController
        .listen(FirebaseAuth.instance.currentUser?.uid ?? 'unknown');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () async {
            user = await WaitingDialog.show<Map<String, dynamic>?>(context,
                future: FirestoreService.getUser(
                    FirebaseAuth.instance.currentUser?.uid ?? 'unknown'));
            setState(() {});
          },
        ),
        if (user != null)
          Text(
            user.toString(),
            textAlign: TextAlign.center,
          ),
        ListenableBuilder(
            listenable: userDataController,
            builder: (context, _) {
              return Text(
                userDataController.userData.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueAccent),
              );
            }),
        const SizedBox(
          height: 72,
        ),
        ValueListenableBuilder<UserModel?>(
            valueListenable: userDataController.userModelNotifier,
            builder: (context, user, _) {
              if (user == null) {
                return const Text(
                  "DataModel is null!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blueAccent),
                );
              }
              return Text(
                user.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.blueAccent),
              );
            }),

        IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              try {
                UserModel model1 =
                    UserModel(uid: "uid", siblings: const ["A", "B", "C"]);
                UserModel model2 =
                    UserModel(uid: "uid", siblings: const ["A", "2", "C"]);
                print(model1 == model2);
              } catch (e) {
                print(e);
              }
            }),
      ],
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
