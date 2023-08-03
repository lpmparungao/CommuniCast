import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:communicast/models/user.dart' as model;
import 'package:communicast/resources/snackbar.dart';
import 'package:communicast/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user details
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  Future<void> updateProfile({
    required String bio,
    required String firstName,
    required String lastName,
  }) async {
    if (bio.isNotEmpty || firstName.isNotEmpty || lastName.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);
      await userRef.update({
        'bio': bio,
        'firstName': firstName,
        'lastName': lastName,
      });
    }
  }

  Future<void> updatePic({
    required Uint8List file,
  }) async {
    if (file.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);
      await userRef.update({
        'photoUrl': photoUrl,
      });
    }
  }

  Future<void> updateUser({
    required String bio,
    required Uint8List file,
  }) async {
    if (bio.isNotEmpty || file.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user!.uid);
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('profilePics', file, false);
      await userRef.update({
        'bio': bio,
        'photoUrl': photoUrl,
      });
    }
  }

  // Signing Up User

  Future<String> signUpUser({
    required String email,
    required String firstName,
    required String lastName,
    required String birthDate,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
    required BuildContext context,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //check if username exists
        QuerySnapshot querySnapshot = await _firestore
            .collection("users")
            .where("username", isEqualTo: username)
            .get();
        if (querySnapshot.docs.length > 0) {
          return "Username already exists";
        } else {
          // registering user in auth with email and password
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await sendEmailVerification(context);

          String photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);

          model.User _user = model.User(
            username: username,
            firstName: firstName,
            lastName: lastName,
            birthDate: birthDate,
            uid: cred.user!.uid,
            photoUrl: photoUrl,
            email: email,
            bio: bio,
            followers: [],
            following: [],
          );

          // adding user in our database
          await _firestore
              .collection("users")
              .doc(cred.user!.uid)
              .set(_user.toJson());

          res = "success";
          showSnackBar(
              context, 'Email Verification Sent. Please verify your email');
        }
      } else {
        res = "Please enter all the fields";
        return "Please enter all the fields";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        return 'The email is invalid.';
      } else {}

      print(e);
      return e.toString();
    }
    return res;
  }

  // logging in user
  Future<String> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error Occurred";
    try {
      // logging in user with email and password
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      res = "checking verification status...";
      if (!_auth.currentUser!.emailVerified) {
        sendEmailVerification(context);
        res = "Account is not verified.";
        print("Account is not verified. Please verify your email");
        await _auth.signOut();
        return "Account is not verified. Please verify your email";
      } else {
        print("success");
        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      //showSnackBar(context, e.message!);
      if (e.code == 'invalid-email') {
        return 'The email is invalid.';
      } else if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {}

      print(e);
      return e.toString();
    }
    return res;
  }

  //EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      print(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
