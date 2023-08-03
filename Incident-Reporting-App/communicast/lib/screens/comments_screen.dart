import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/models/user.dart';
import 'package:communicast/providers/user_provider.dart';
import 'package:communicast/resources/firestore_methods.dart';
import 'package:communicast/responsive/mobile_screen_layout.dart';
import 'package:communicast/responsive/responsive_layout.dart';
import 'package:communicast/responsive/web_screen_layout.dart';
import 'package:communicast/utils/colors.dart';
import 'package:communicast/utils/utils.dart';
import 'package:communicast/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool isLatest = false;
  bool isOldest = true;
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Comments',
              style: AppTextStyles.title1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  // /width: MediaQuery.of(context).size.width / 2.5,
                  decoration: BoxDecoration(
                    color: AppColors.greyAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLatest = true;
                            isOldest = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isLatest
                                ? AppColors.blueAccent
                                : AppColors.greyAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text('Latest',
                              style: AppTextStyles.body3.copyWith(
                                  color: isLatest
                                      ? AppColors.greyAccent
                                      : AppColors.blueAccent,
                                  fontWeight:
                                      isLatest ? FontWeight.bold : null)),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLatest = false;
                            isOldest = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isOldest
                                ? AppColors.blueAccent
                                : AppColors.greyAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Text('Oldest',
                              style: AppTextStyles.body3.copyWith(
                                  color: isOldest
                                      ? AppColors.greyAccent
                                      : AppColors.blueAccent,
                                  fontWeight:
                                      isOldest ? FontWeight.bold : null)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  type: PageTransitionType.topToBottom,
                  duration: const Duration(milliseconds: 200),
                  child: ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  ),
                ),
                (route) => false);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.black,
            size: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: isLatest
            ? FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .orderBy("datePublished", descending: true)
                .snapshots()
            : FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .orderBy("datePublished", descending: false)
                .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              Container(
                height: 40,
                width: 40,
                color: AppColors.greyAccent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    user.photoUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      hintStyle: AppTextStyles.body.copyWith(
                        color: AppColors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  user.uid,
                  user.username,
                  user.photoUrl,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Text(
                    'Comment',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.blueAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
