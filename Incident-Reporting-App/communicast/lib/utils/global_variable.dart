import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:communicast/screens/add_post_screen.dart';
import 'package:communicast/screens/feed_screen.dart';
import 'package:communicast/screens/notification_screen.dart';
import 'package:communicast/screens/profile_screen.dart';
import 'package:communicast/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const FeedScreen(),
  const AddPostScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
