import 'dart:developer';
import 'dart:io';

import 'package:crud_supabase/core/services/supabase_services.dart';
import 'package:crud_supabase/data/model/model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProvider extends ChangeNotifier {
  final supaServices = SupabaseServices();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  List<UserModel> users = [];

  Future<void> fetchUsers() async {
    final users = await supaServices.fetchUsers();
    this.users = users;
    log('users: $users');
    notifyListeners();
  }

  Future<void> addUser(UserModel user) async {
    await supaServices.addUser(user);
    fetchUsers();
  }

  Future<void> updateUser(UserModel user) async {
    await supaServices.updateUser(user);
    fetchUsers();
  }

  Future<void> deleteUser(int id) async {
    await supaServices.deleteUser(id);
    fetchUsers();
  }

  Future<XFile?> pickImage() async {
    final pickedFile = await supaServices.pickImage();
    return pickedFile;
  }

  Future<void> uploadImage(XFile image) async {
    await supaServices.uploadImage(File(image.path));
  }
}
