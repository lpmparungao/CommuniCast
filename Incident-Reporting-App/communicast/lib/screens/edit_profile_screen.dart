import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communicast/widgets/text_field_edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/responsive/mobile_screen_layout.dart';
import 'package:communicast/responsive/responsive_layout.dart';
import 'package:communicast/responsive/web_screen_layout.dart';
import 'package:communicast/utils/utils.dart';

import '../resources/auth_methods.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  Uint8List? _image;
  var userData = {};
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  void update() async {
    await AuthMethods().updateProfile(
      bio: _bioController.text,
      firstName: _firstnameController.text,
      lastName: _lastnameController.text,
    );
  }

  void updatePic() async {
    await AuthMethods().updatePic(file: _image!);
  }

  //get user details
  Future<void> getUserDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);

    final doc = await userRef.get();
    if (doc.exists) {
      setState(() {
        userData = doc.data()!;
        _usernameController.text = doc['username'];
        _emailController.text = doc['email'];
        _birthdateController.text = doc['birthDate'];
        _firstnameController.text = doc['firstName'];
        _lastnameController.text = doc['lastName'];
        _bioController.text = doc['bio'];
      });
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.white,
            centerTitle: true,
            elevation: 0,
            title: const Text(
              'Edit Profile',
              style: AppTextStyles.title1,
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.black,
                size: 20,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        backgroundColor: AppColors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 120,
                      child: Stack(
                        children: [
                          _image != null
                              ? Container(
                                  height: 100,
                                  width: 100,
                                  color: AppColors.greyAccent,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.memory(_image!,
                                          fit: BoxFit.cover)),
                                )
                              : Container(
                                  height: 100,
                                  width: 100,
                                  color: AppColors.greyAccent,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      userData['photoUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          Positioned(
                            bottom: 0,
                            left: 60,
                            child: IconButton(
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: AppColors.grey,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Username",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textFields,
                ),
                Text(
                  _usernameController.text,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Email",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textFields,
                ),
                Text(
                  _emailController.text,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Birthdate",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textFields,
                ),
                Text(
                  _birthdateController.text,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Username, email, and birthdate details cannot be changed after submission.',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "First Name",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textFields,
                ),
                TextFieldEdit(
                  hintText: 'First Name',
                  textInputType: TextInputType.text,
                  textEditingController: _firstnameController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Last Name",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textFields,
                ),
                TextFieldEdit(
                  hintText: 'Last Name',
                  textInputType: TextInputType.text,
                  textEditingController: _lastnameController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Bio",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.textFields,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  controller: _bioController,
                  style: AppTextStyles.body,
                  decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: AppColors.blueAccent, width: 2),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.black),
                      ),
                      hintText: "Bio",
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.grey,
                      ),
                      border: InputBorder.none),
                  //maxLines: 8,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_firstnameController.text == "" ||
                              _bioController.text == "" ||
                              _lastnameController.text == "") {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  content: Text('Fields cannot be empty'),
                                );
                              },
                            );
                          } else {
                            update();
                            updatePic();
                            Navigator.of(context).pushAndRemoveUntil(
                                PageTransition(
                                  type: PageTransitionType.fade,
                                  duration: const Duration(milliseconds: 200),
                                  child: const ResponsiveLayout(
                                    mobileScreenLayout: MobileScreenLayout(),
                                    webScreenLayout: WebScreenLayout(),
                                  ),
                                ),
                                (route) => false);
                          }
                        },
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10)),
                          // backgroundColor:
                          //     MaterialStateProperty.all<Color>(Colors.blueAccent),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Save',
                              style: AppTextStyles.button,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
