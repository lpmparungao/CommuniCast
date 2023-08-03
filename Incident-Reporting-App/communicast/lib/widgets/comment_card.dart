import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:communicast/constants.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            color: AppColors.greyAccent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                snap.data()['profilePic'],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                            text: snap.data()['name'],
                            style: AppTextStyles.body2.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
                        TextSpan(
                            text: ' ${snap.data()['text']}',
                            style: AppTextStyles.body2),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: RichText(
                      text: TextSpan(
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.grey,
                        ),
                        children: [
                          TextSpan(
                            text: DateFormat.jm()
                                .format(snap.data()['datePublished'].toDate()),
                          ),
                          const TextSpan(
                            text: ' • ',
                          ),
                          TextSpan(
                            text: DateFormat.yMMMd()
                                .format(snap.data()['datePublished'].toDate()),
                          ),
                        ],
                      ),
                    ),
                    // Text(
                    //   DateFormat.yMMMd().format(
                    //     snap.data()['datePublished'].toDate(),
                    //   ),
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w400,
                    //   ),
                    // ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
