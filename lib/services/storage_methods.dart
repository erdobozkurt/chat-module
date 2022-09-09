import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageMethods {
  final _storage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  //* adding image to firebase storage
  Future<String> uploadImage(PickedFile pickedFile) async {
    
    final file = File(pickedFile.path);

    final ref = _storage.ref().child(_auth.currentUser!.uid);

    UploadTask uploadTask = ref.putFile(file);

    final snapshot = await uploadTask;

    String urlDownload = await snapshot.ref.getDownloadURL();
    return urlDownload;
  }
}
