import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadFile(String filePath, String fileName) async {
    try {
      final ref = _storage.ref().child(fileName);
      final uploadTask = ref.putFile(File(filePath));
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> deleteFile(String fileName) async {
    try {
      await _storage.ref().child(fileName).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  // Add more storage operations as needed
}