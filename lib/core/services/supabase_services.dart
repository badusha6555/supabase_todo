import 'dart:developer';
import 'dart:io';

import 'package:crud_supabase/data/model/model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseServices {
  final client = Supabase.instance.client;
  // final bucket = "images";
  // final storage = Supabase.instance.client.storage;

  final picker = ImagePicker();

  Future<List<UserModel>> fetchUsers() async {
    try {
      final response = await client.from('users').select('*');
      final users = response as List<UserModel>;
      return users;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      final response = await client.from('users').insert(user.toJson());
      log(response);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      final response = await client.from('users').update(user.toJson());
      log(response);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteUser(int id) async {
    try {
      final response = await client.from('users').delete().eq('id', id);
      log(response);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<XFile?> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  Future<void> uploadImage(File image) async {
    final supabase = Supabase.instance.client;

    final bucketName = 'images';
    final fileName = DateTime.now().toIso8601String() + '.jpg';

    try {
      final response =
          await supabase.storage.from(bucketName).upload(fileName, image);

      if (response != null) {
        final publicUrl =
            supabase.storage.from(bucketName).getPublicUrl(fileName);

        print('File uploaded successfully. Public URL: $publicUrl');
      } else {
        throw Exception('Failed to upload: ${response.length}');
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }
}
