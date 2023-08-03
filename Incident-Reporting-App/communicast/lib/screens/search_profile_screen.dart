import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communicast/responsive/mobile_screen_layout.dart';
import 'package:communicast/responsive/responsive_layout.dart';
import 'package:communicast/responsive/web_screen_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/resources/auth_methods.dart';
import 'package:communicast/resources/firestore_methods.dart';
import 'package:communicast/screens/login_screen.dart';
import 'package:communicast/utils/colors.dart';
import 'package:communicast/utils/global_variable.dart';
import 'package:communicast/utils/utils.dart';
import 'package:communicast/widgets/follow_button.dart';
import 'package:communicast/widgets/like_animation.dart';
import 'package:page_transition/page_transition.dart';

class SearchProfileScreen extends StatefulWidget {
  final String uid;
  const SearchProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _SearchProfileScreenState createState() => _SearchProfileScreenState();
}

class _SearchProfileScreenState extends State<SearchProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

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
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: Text(
                userData['username'],
                style: AppTextStyles.title1,
              ),
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.black,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        duration: const Duration(milliseconds: 200),
                        child: ResponsiveLayout(
                          mobileScreenLayout: MobileScreenLayout(),
                          webScreenLayout: WebScreenLayout(),
                        ),
                      ),
                      (route) => false);
                },
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
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
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Edit Profile',
                                            backgroundColor: AppColors.white,
                                            textColor: AppColors.black,
                                            borderColor: AppColors.grey,
                                            function: () {
                                              Navigator.pushNamed(
                                                  context, '/editProfile');
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: AppColors.black,
                                                borderColor:
                                                    AppColors.greyAccentLine,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor:
                                                    AppColors.blueAccent,
                                                textColor: AppColors.white,
                                                borderColor:
                                                    AppColors.blueAccent,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
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
                      if (widget.uid == FirebaseAuth.instance.currentUser!.uid)
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
                          .where('uid', isEqualTo: widget.uid)
                          .get(),
                      builder: (context, snapshot) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        // }
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
                                      MediaQuery.of(context).size.height / 1.5,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        (snapshot.data! as dynamic).docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot snap =
                                          (snapshot.data! as dynamic)
                                              .docs[index];

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
                                                                          showDialog(
                                                                              useRootNavigator: false,
                                                                              context: context,
                                                                              builder: (context) {
                                                                                return Dialog(
                                                                                  child: ListView(
                                                                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                                                                      shrinkWrap: true,
                                                                                      children: [
                                                                                        'Delete',
                                                                                      ]
                                                                                          .map(
                                                                                            (e) => InkWell(
                                                                                                child: Container(
                                                                                                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
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
                                                                                                        e,
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
                                                                                          )
                                                                                          .toList()),
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
                                                                          widget
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
                                                                        widget
                                                                            .uid,
                                                                        snap[
                                                                            'likes'],
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .campaign_rounded,
                                                                      color: snap['likes'].contains(widget
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
                                                                        .body3
                                                                        .copyWith(
                                                                  color:
                                                                      AppColors
                                                                          .grey,
                                                                ),
                                                                children: [
                                                                  TextSpan(
                                                                    text: DateFormat
                                                                            .jm()
                                                                        .format(
                                                                            snap['datePublished'].toDate()),
                                                                  ),
                                                                  TextSpan(
                                                                    text: ' • ',
                                                                  ),
                                                                  TextSpan(
                                                                    text: DateFormat
                                                                            .yMMMd()
                                                                        .format(
                                                                      snap['datePublished']
                                                                          .toDate(),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              snap['location'],
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
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
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
