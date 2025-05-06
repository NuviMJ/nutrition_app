import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:nutrition_app/features/storage/domain/repo/storage_repo.dart';

class FirebaseStorageRepo implements StorageRepo {
  final FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
   return _uploadFile(path, fileName);
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, 'profile_images');
  }

  Future<String?> _uploadFile(String path, String fileName) async {
    try {
      final file = File(path);
      final storageRef = storage.ref().child('uploads/$fileName');
      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;

    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }
  Future<String?> _uploadFileBytes(Uint8List fileBytes, String fileName, String folder) async {
    try {
      final storageRef = storage.ref().child('$folder/$fileName');
      final uploadTask = await storageRef.putData(fileBytes);
      final downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Error uploading file: $e');
    }
  }
}
