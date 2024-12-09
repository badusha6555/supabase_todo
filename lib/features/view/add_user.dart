import 'dart:io';

import 'package:crud_supabase/data/model/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/view_model.dart';

class AddUser extends StatefulWidget {
  final Map<String, dynamic>? user;
  const AddUser({
    super.key,
    this.user,
  });

  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _age;
  File? _imageUrl;
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<UserProvider>(builder: (context, userProvider, child) {
          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    userProvider.pickImage().then((image) {
                      setState(() {
                        _imageUrl = File(image!.path);
                      });
                    });
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageUrl != null
                        ? FileImage(_imageUrl!) as ImageProvider
                        : null,
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    initialValue: widget.user != null
                        ? widget.user!['name']
                        : userProvider.nameController.text,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                    initialValue: widget.user != null
                        ? widget.user!['age']
                        : userProvider.ageController.text,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your age';
                      }
                      return null;
                    }),
                SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() == true) {
                        if (widget.user == null) {
                          userProvider.addUser(
                            UserModel(
                              id: userProvider.users.length + 1,
                              name: _name ?? "",
                              age: _age ?? 0,
                              image: _imageUrl!.path,
                            ),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text('Add User')),
              ],
            ),
          );
        }),
      ),
    );
  }
}
