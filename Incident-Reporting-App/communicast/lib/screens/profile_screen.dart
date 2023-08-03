import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/resources/firestore_methods.dart';
import 'package:communicast/screens/settings_screen.dart';
import 'package:communicast/utils/utils.dart';
import 'package:communicast/widgets/follow_button.dart';
import 'package:communicast/widgets/like_animation.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  var userData = {};
  int postLen = 0;
  List<int> likes = [];
  int postsLikesCount = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool isEdited = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: user!.uid)
          .get();

      likes = postSnap.docs
          .map((e) => e.data()['likes'].length)
          .toList()
          .cast<int>();
      if (likes.isEmpty) {
        likes.add(0);
      }

      //likes count getter
      postsLikesCount =
          likes.fold(0, (previousValue, element) => previousValue + element);
      // print(likes);
      // print(postsLikesCount);

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap.data()!['followers'].contains(user!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  deletePost(String postId) async {
    try {
      await FireStoreMethods().deletePost(postId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  //edit post
  editPost(
      String postId, String title, String description, String indicator) async {
    try {
      await FireStoreMethods().editPost(postId, title, description, indicator);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController indicatorController = TextEditingController();
  List<String> _indicators = [
    'CODE RED',
    'CODE AMBER',
    'CODE BLUE',
    'CODE GREEN',
    'CODE BLACK',
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.white,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userData['username'],
                    style: AppTextStyles.title1,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.fade,
                              duration: const Duration(milliseconds: 500),
                              child: const SettingsScreen()));
                    },
                    child: Icon(
                      Icons.settings_rounded,
                      color: AppColors.grey,
                      size: 20,
                    ),
                  )
                ],
              ),
              centerTitle: false,
              elevation: 0,
            ),
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            color: AppColors.greyAccent,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                userData['photoUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FollowButton(
                                      text: 'Edit Profile',
                                      backgroundColor: AppColors.white,
                                      textColor: AppColors.black,
                                      borderColor: AppColors.grey,
                                      function: () {
                                        Navigator.pushNamed(
                                            context, '/editProfile');
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 10,
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: userData['firstName'],
                                  style: AppTextStyles.body.copyWith(
                                    fontWeight: FontWeight.bold,
                                  )),
                              const TextSpan(
                                text: " ",
                              ),
                              TextSpan(
                                  text: userData['lastName'],
                                  style: AppTextStyles.body
                                      .copyWith(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          userData['email'],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: Text(
                          userData['bio'],
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("posts")
                      .orderBy("datePublished", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .where('uid', isEqualTo: user!.uid)
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            if ((snapshot.data! as dynamic).docs.length == 0) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 340,
                                child: Center(
                                  child: Text(
                                    'No posts yet',
                                    style: AppTextStyles.body,
                                  ),
                                ),
                              );
                            } else {
                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height - 340,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        (snapshot.data! as dynamic).docs.length,
                                    itemBuilder: (context, index) {
                                      List<QueryDocumentSnapshot> sortedDocs =
                                          (snapshot.data! as dynamic).docs;
                                      sortedDocs.sort((a, b) =>
                                          b["datePublished"]
                                              .compareTo(a["datePublished"]));
                                      DocumentSnapshot snap = sortedDocs[index];

                                      String indicator = snap['indicator'];
                                      var icon = 61242;
                                      Color color = Colors.white;

                                      if (indicator == 'CODE RED') {
                                        icon = 57912;
                                        color = Colors.red;
                                      } else if (indicator == 'CODE AMBER') {
                                        icon = 983712;
                                        color = Colors.amber;
                                      } else if (indicator == 'CODE BLUE') {
                                        icon = 983744;
                                        color = Colors.blue;
                                      } else if (indicator == 'CODE GREEN') {
                                        icon = 983699;
                                        color = Colors.green;
                                      } else if (indicator == 'CODE BLACK') {
                                        icon = 62784;
                                        color = Colors.black;
                                      }

                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 130,
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 10,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      bottomLeft:
                                                          Radius.circular(10),
                                                    ),
                                                    color: color,
                                                  ),
                                                  child: Icon(
                                                    IconData(
                                                      icon,
                                                      fontFamily:
                                                          'MaterialIcons',
                                                    ),
                                                    color: AppColors.white,
                                                    size: 25,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                SizedBox(
                                                  height: 130,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: width - 85,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                    snap[
                                                                        'title'],
                                                                    style: AppTextStyles
                                                                        .body
                                                                        .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      //color: color,
                                                                    )),
                                                                snap['uid'].toString() ==
                                                                        user!
                                                                            .uid
                                                                    ? GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          titleController.text =
                                                                              snap['title'];
                                                                          descriptionController.text =
                                                                              snap['description'];
                                                                          indicatorController.text =
                                                                              snap['indicator'];
                                                                          showDialog(
                                                                              useRootNavigator: false,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return Dialog(
                                                                                  child: ListView(
                                                                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                                                                    shrinkWrap: true,
                                                                                    children: [
                                                                                      InkWell(
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                            child: Row(
                                                                                              children: const [
                                                                                                Icon(
                                                                                                  Icons.edit,
                                                                                                  color: Colors.blue,
                                                                                                ),
                                                                                                SizedBox(
                                                                                                  width: 10,
                                                                                                ),
                                                                                                Text(
                                                                                                  'Edit',
                                                                                                  style: AppTextStyles.body,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          onTap: () {
                                                                                            Navigator.of(context).pop();
                                                                                            showDialog(
                                                                                                context: context,
                                                                                                barrierDismissible: false, //user must tap button
                                                                                                builder: (BuildContext context) {
                                                                                                  return AlertDialog(
                                                                                                    backgroundColor: AppColors.white,
                                                                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                                                                                    contentPadding: const EdgeInsets.only(top: 30.0, right: 30, left: 30),
                                                                                                    title: Text(
                                                                                                      'Edit Report',
                                                                                                      style: AppTextStyles.title.copyWith(
                                                                                                        color: AppColors.black,
                                                                                                      ),
                                                                                                    ),
                                                                                                    content: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                                                                      return SingleChildScrollView(
                                                                                                        child: ListBody(
                                                                                                          children: <Widget>[
                                                                                                            TextField(
                                                                                                              inputFormatters: [
                                                                                                                LengthLimitingTextInputFormatter(15)
                                                                                                              ],
                                                                                                              controller: titleController,
                                                                                                              style: AppTextStyles.body,
                                                                                                              decoration: InputDecoration(
                                                                                                                focusedBorder: const UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(color: AppColors.blueAccent, width: 2),
                                                                                                                ),
                                                                                                                enabledBorder: const UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(color: AppColors.black),
                                                                                                                ),
                                                                                                                border: InputBorder.none,
                                                                                                                hintText: "Title of the Incident",
                                                                                                                labelText: "Title of the Incident",
                                                                                                                labelStyle: AppTextStyles.subtitle.copyWith(
                                                                                                                  color: AppColors.grey,
                                                                                                                  fontWeight: FontWeight.w400,
                                                                                                                ),
                                                                                                                hintStyle: AppTextStyles.body.copyWith(
                                                                                                                  color: AppColors.grey,
                                                                                                                ),
                                                                                                                contentPadding: const EdgeInsets.all(0),
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 20,
                                                                                                            ),
                                                                                                            TextField(
                                                                                                              controller: descriptionController,
                                                                                                              style: AppTextStyles.body,
                                                                                                              maxLines: null,
                                                                                                              decoration: InputDecoration(
                                                                                                                focusedBorder: const UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(color: AppColors.blueAccent, width: 2),
                                                                                                                ),
                                                                                                                enabledBorder: const UnderlineInputBorder(
                                                                                                                  borderSide: BorderSide(color: AppColors.black),
                                                                                                                ),
                                                                                                                border: InputBorder.none,
                                                                                                                hintText: "Description of the Incident",
                                                                                                                labelText: "Description of the Incident",
                                                                                                                labelStyle: AppTextStyles.subtitle.copyWith(
                                                                                                                  color: AppColors.grey,
                                                                                                                  fontWeight: FontWeight.w400,
                                                                                                                ),
                                                                                                                hintStyle: AppTextStyles.body.copyWith(
                                                                                                                  color: AppColors.grey,
                                                                                                                ),
                                                                                                                contentPadding: const EdgeInsets.all(0),
                                                                                                              ),
                                                                                                            ),
                                                                                                            SizedBox(
                                                                                                              height: 20,
                                                                                                            ),
                                                                                                            Text('Report Indicator',
                                                                                                                style: AppTextStyles.body3.copyWith(
                                                                                                                  color: AppColors.grey,
                                                                                                                  fontWeight: FontWeight.w400,
                                                                                                                )),
                                                                                                            DropdownButtonHideUnderline(
                                                                                                              child: DropdownButton2(
                                                                                                                hint: Text(
                                                                                                                  'Select Report Indicator',
                                                                                                                  style: AppTextStyles.body.copyWith(
                                                                                                                    color: AppColors.grey,
                                                                                                                  ),
                                                                                                                ),
                                                                                                                items: _indicators
                                                                                                                    .map((item) => DropdownMenuItem<String>(
                                                                                                                          value: item,
                                                                                                                          child: Text(item, style: AppTextStyles.body),
                                                                                                                        ))
                                                                                                                    .toList(),
                                                                                                                value: indicatorController.text,
                                                                                                                onChanged: (value) {
                                                                                                                  setState(() {
                                                                                                                    indicatorController.text = value as String;
                                                                                                                  });
                                                                                                                },
                                                                                                                buttonHeight: 40,
                                                                                                                buttonWidth: 340,
                                                                                                                itemHeight: 40,
                                                                                                                icon: const Icon(
                                                                                                                  Icons.arrow_drop_down,
                                                                                                                  color: AppColors.grey,
                                                                                                                ),
                                                                                                              ),
                                                                                                            ),
                                                                                                          ],
                                                                                                        ),
                                                                                                      );
                                                                                                    }),
                                                                                                    actions: <Widget>[
                                                                                                      TextButton(
                                                                                                        child: Text(
                                                                                                          'OK',
                                                                                                          style: AppTextStyles.body.copyWith(
                                                                                                            color: AppColors.black,
                                                                                                          ),
                                                                                                        ),
                                                                                                        onPressed: () {
                                                                                                          //update post
                                                                                                          editPost(snap['postId'].toString(), titleController.text, descriptionController.text, indicatorController.text);

                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                      TextButton(
                                                                                                        child: Text(
                                                                                                          'Cancel',
                                                                                                          style: AppTextStyles.body.copyWith(
                                                                                                            color: AppColors.black,
                                                                                                          ),
                                                                                                        ),
                                                                                                        onPressed: () {
                                                                                                          Navigator.of(context).pop();
                                                                                                        },
                                                                                                      ),
                                                                                                    ],
                                                                                                  );
                                                                                                });
                                                                                          }),
                                                                                      InkWell(
                                                                                          child: Container(
                                                                                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                                                            child: Row(
                                                                                              children: [
                                                                                                const Icon(
                                                                                                  Icons.delete_outline_rounded,
                                                                                                  color: Colors.red,
                                                                                                ),
                                                                                                const SizedBox(
                                                                                                  width: 10,
                                                                                                ),
                                                                                                Text(
                                                                                                  'Delete',
                                                                                                  style: AppTextStyles.body,
                                                                                                ),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          onTap: () {
                                                                                            deletePost(
                                                                                              snap['postId'].toString(),
                                                                                            );
                                                                                            // remove the dialog box
                                                                                            Navigator.of(context).pop();
                                                                                          }),
                                                                                    ],
                                                                                  ),
                                                                                );
                                                                              });
                                                                        },
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .more_vert,
                                                                          color:
                                                                              Colors.grey,
                                                                          size:
                                                                              15,
                                                                        ),
                                                                      )
                                                                    : Container(),
                                                              ],
                                                            ),
                                                            Text(
                                                              snap[
                                                                  'description'],
                                                              maxLines: 2,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  AppTextStyles
                                                                      .body2,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            85,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                LikeAnimation(
                                                                  isAnimating: snap[
                                                                          'likes']
                                                                      .contains(
                                                                          user!
                                                                              .uid),
                                                                  smallLike:
                                                                      true,
                                                                  child:
                                                                      GestureDetector(
                                                                    onTap: () {
                                                                      FireStoreMethods()
                                                                          .likePost(
                                                                        snap['postId']
                                                                            .toString(),
                                                                        user!
                                                                            .uid,
                                                                        snap[
                                                                            'likes'],
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .campaign_rounded,
                                                                      color: snap['likes'].contains(user!
                                                                              .uid)
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .grey,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Text(
                                                                  '${snap['likes'].length} casts',
                                                                  style:
                                                                      AppTextStyles
                                                                          .body2,
                                                                ),
                                                              ],
                                                            ),
                                                            RichText(
                                                              text: TextSpan(
                                                                style:
                                                                    AppTextStyles
                                                                        .body3,
                                                                children: [
                                                                  TextSpan(
                                                                    text: DateFormat
                                                                            .jm()
                                                                        .format(
                                                                            snap['datePublished'].toDate()),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: AppColors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  const TextSpan(
                                                                    text: ' • ',
                                                                    style:
                                                                        TextStyle(
                                                                      color: AppColors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                  TextSpan(
                                                                    text: DateFormat
                                                                            .yMMMd()
                                                                        .format(
                                                                      snap['datePublished']
                                                                          .toDate(),
                                                                    ),
                                                                    style:
                                                                        const TextStyle(
                                                                      color: AppColors
                                                                          .grey,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              snap['location'],
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  AppTextStyles
                                                                      .body3
                                                                      .copyWith(
                                                                color: AppColors
                                                                    .grey,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Divider(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            }
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(), style: AppTextStyles.title1),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
