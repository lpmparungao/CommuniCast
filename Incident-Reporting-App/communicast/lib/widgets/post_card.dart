import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:communicast/codes.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/models/user.dart' as model;
import 'package:communicast/providers/user_provider.dart';
import 'package:communicast/resources/firestore_methods.dart';
import 'package:communicast/screens/comments_screen.dart';
import 'package:communicast/screens/search_profile_screen.dart';
import 'package:communicast/utils/colors.dart';
import 'package:communicast/utils/global_variable.dart';
import 'package:communicast/utils/utils.dart';
import 'package:communicast/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PostCard extends StatefulWidget {
  final snap;

  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    fetchCommentLen();
  }

  fetchCommentLen() async {
    try {
      //fetch comment length in real time
      FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .snapshots()
          .listen((event) {
        commentLen = event.docs.length;
        if (mounted) setState(() {});
      });
      // QuerySnapshot snap = await FirebaseFirestore.instance
      //     .collection('posts')
      //     .doc(widget.snap['postId'])
      //     .collection('comments')
      //     .get();
      // commentLen = snap.docs.length;
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    if (mounted) setState(() {});
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
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final width = MediaQuery.of(context).size.width;

    String indicator = widget.snap['indicator'];
    var icon = 61242;
    Color color = Colors.white;
    String codeTitle = '';
    String codeDescription = '';
    String hotline = '';

    if (indicator == 'CODE RED') {
      icon = 57912;
      color = Colors.red;
      codeTitle = codeRed;
      codeDescription = codeRedDesc;
      hotline = hotlineRed;
    } else if (indicator == 'CODE AMBER') {
      icon = 983712;
      color = Colors.amber;
      codeTitle = codeAmber;
      codeDescription = codeAmberDesc;
      hotline = hotlineAmber;
    } else if (indicator == 'CODE BLUE') {
      icon = 983744;
      color = Colors.blue;
      codeTitle = codeBlue;
      codeDescription = codeBlueDesc;
      hotline = hotlineBlue;
    } else if (indicator == 'CODE GREEN') {
      icon = 983699;
      color = Colors.green;
      codeTitle = codeGreen;
      codeDescription = codeGreenDesc;
      hotline = hotlineGreen;
    } else if (indicator == 'CODE BLACK') {
      icon = 62784;
      color = Colors.black;
      codeTitle = codeBlack;
      codeDescription = codeBlackDesc;
      hotline = hotlineBlack;
    }

    return Container(
      // boundary needed for web
      decoration: BoxDecoration(
        // border: Border.symmetric(
        //   horizontal: BorderSide(
        //     color: width > webScreenSize
        //         ? AppColors.greyAccentLine
        //         : AppColors.greyAccentLine,
        //   ),
        // ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(
        bottom: 5,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                // CircleAvatar(
                //   radius: 16,
                //   backgroundImage: NetworkImage(
                //     widget.snap['profImage'].toString(),
                //   ),
                // ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SearchProfileScreen(
                        uid: widget.snap['uid'],
                      ),
                    ),
                  ),
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: AppColors.greyAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        widget.snap['profImage'].toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SearchProfileScreen(
                                uid: widget.snap['uid'],
                              ),
                            ),
                          ),
                          child: Text(widget.snap['username'].toString(),
                              style: AppTextStyles.body.copyWith(
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        Text('${widget.snap['location']}',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.grey,
                            )),
                      ],
                    ),
                  ),
                ),
                // widget.snap['uid'].toString() == user.uid
                //     ? IconButton(
                //         onPressed: () {
                //           showDialog(
                //             useRootNavigator: false,
                //             context: context,
                //             builder: (context) {
                //               return Dialog(
                //                 child: ListView(
                //                     padding: const EdgeInsets.symmetric(
                //                         vertical: 16),
                //                     shrinkWrap: true,
                //                     children: [
                //                       'Delete',
                //                     ]
                //                         .map(
                //                           (e) => InkWell(
                //                               child: Container(
                //                                 padding:
                //                                     const EdgeInsets.symmetric(
                //                                         vertical: 5,
                //                                         horizontal: 16),
                //                                 child: Row(
                //                                   children: [
                //                                     const Icon(
                //                                       Icons
                //                                           .delete_outline_rounded,
                //                                       color: Colors.red,
                //                                     ),
                //                                     const SizedBox(
                //                                       width: 10,
                //                                     ),
                //                                     Text(
                //                                       e,
                //                                       style: AppTextStyles.body,
                //                                     ),
                //                                   ],
                //                                 ),
                //                               ),
                //                               onTap: () {
                //                                 deletePost(
                //                                   widget.snap['postId']
                //                                       .toString(),
                //                                 );
                //                                 // remove the dialog box
                //                                 Navigator.of(context).pop();
                //                               }),
                //                         )
                //                         .toList()),
                //               );
                //             },
                //           );
                //         },
                //         icon: const Icon(Icons.more_vert,
                //             color: AppColors.grey, size: 15),
                //       )
                //     : Container(),
              ],
            ),
          ),
          // IMAGE SECTION OF THE POST
          GestureDetector(
            onDoubleTap: () {
              FireStoreMethods().likePost(
                widget.snap['postId'].toString(),
                user.uid,
                widget.snap['likes'],
              );
              if (mounted)
                setState(() {
                  isLikeAnimating = true;
                });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      if (mounted)
                        setState(() {
                          isLikeAnimating = false;
                        });
                    },
                    child: const Icon(
                      Icons.campaign_rounded,
                      color: Colors.white,
                      size: 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // LIKE, COMMENT SECTION OF THE POST
          Container(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                LikeAnimation(
                  isAnimating: widget.snap['likes'].contains(user.uid),
                  smallLike: true,
                  child: GestureDetector(
                    onTap: () {
                      FireStoreMethods().likePost(
                        widget.snap['postId'].toString(),
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    child: Icon(
                      Icons.campaign_rounded,
                      color: widget.snap['likes'].contains(user.uid)
                          ? Colors.red
                          : Colors.grey,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.snap['likes'].length} casts',
                  style: AppTextStyles.body2,
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          duration: const Duration(milliseconds: 300),
                          child: CommentsScreen(
                            postId: widget.snap['postId'].toString(),
                          ),
                        ));
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => CommentsScreen(
                    //       postId: widget.snap['postId'].toString(),
                    //     ),
                    //   ),
                    // );
                  },
                  child: const Icon(
                    Icons.comment_rounded,
                    size: 20,
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.bottomToTop,
                          duration: const Duration(milliseconds: 300),
                          child: CommentsScreen(
                            postId: widget.snap['postId'].toString(),
                          ),
                        ));
                  },
                  child: Text(
                    '$commentLen comments',
                    style: AppTextStyles.body2,
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: AppColors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                              contentPadding: const EdgeInsets.only(
                                  top: 30.0, right: 30, left: 30),
                              //title:
                              content: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.35,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            codeTitle,
                                            style: AppTextStyles.title.copyWith(
                                              color: color,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            codeDescription,
                                            style: AppTextStyles.body,
                                            textAlign: TextAlign.justify,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: AppColors.greyAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Hotlines:',
                                                  style: AppTextStyles.body
                                                      .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  hotline,
                                                  style: AppTextStyles.body,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Row(
                                      //     mainAxisAlignment:
                                      //         MainAxisAlignment.end,
                                      //     children: [
                                      //       GestureDetector(
                                      //         onTap: () {
                                      //           Navigator.of(context).pop(
                                      //               false); //Will not exit the App
                                      //         },
                                      //         child: Text(
                                      //           'OK',
                                      //           style:
                                      //               AppTextStyles.body.copyWith(
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ]),
                                    ],
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                // ignore: deprecated_member_use
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pop(false); //Will not exit the App
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      right: 30.0,
                                      bottom: 20,
                                    ),
                                    child: Text(
                                      'OK',
                                      style: AppTextStyles.body.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                // TextButton(
                                //   child: Text(
                                //     'OK',
                                //     style: TextStyle(
                                //         fontSize: 15,
                                //         fontWeight: FontWeight.bold,
                                //         color: Colors.blueGrey),
                                //   ),
                                //   onPressed: () {
                                //     Navigator.of(context)
                                //         .pop(false); //Will not exit the App
                                //   },
                                // ),
                              ],
                            );
                          },
                        );
                      },
                      child: Container(
                        // margin: const EdgeInsets.only(top: 5.0),
                        width: MediaQuery.of(context).size.width / 3.7,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 3,
                          horizontal: 4,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              IconData(icon, fontFamily: 'MaterialIcons'),
                              color: AppColors.white,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              indicator,
                              style: AppTextStyles.body1.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          //DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['title'],
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.snap['description'],
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.black,
                        ),
                      ),
                      // RichText(
                      //   text: TextSpan(
                      //     style: const TextStyle(color: primaryColor),
                      //     children: [
                      //       TextSpan(
                      //         text: widget.snap['username'].toString(),
                      //         style: AppTextStyles.body2.copyWith(
                      //           color: AppColors.black,
                      //           fontWeight: FontWeight.bold,
                      //         ),
                      //       ),
                      //       TextSpan(
                      //         text: ' ${widget.snap['description']}',
                      //         style: AppTextStyles.body2.copyWith(
                      //           color: AppColors.black,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),

                //DATE OF POST
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: AppTextStyles.body3.copyWith(
                            color: AppColors.grey,
                          ),
                          children: [
                            TextSpan(
                              text: DateFormat.jm().format(
                                  widget.snap['datePublished'].toDate()),
                            ),
                            const TextSpan(
                              text: ' • ',
                            ),
                            TextSpan(
                              text: DateFormat.yMMMd().format(
                                  widget.snap['datePublished'].toDate()),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          const Divider(),
        ],
      ),
    );
  }
}
