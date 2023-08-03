import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:communicast/constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Password reset link set. Check your email!'),
            );
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            if (e.code.toString() == 'invalid-email') {
              return AlertDialog(
                content: Text("Email address is not valid."),
              );
            } else if (e.code.toString() == 'user-not-found') {
              return AlertDialog(
                content:
                    Text("There is no user corresponding to the given email."),
              );
            } else {
              return AlertDialog(
                content: Text(e.code.toString()),
              );
            }
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text('Change Password', style: AppTextStyles.title1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.black,
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Enter Your Email",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body,
                ),
              ],
            ),

            SizedBox(height: 10),
            // textfeild
            TextField(
              //autofocus: true,
              controller: _emailController,
              decoration: const InputDecoration(
                fillColor: AppColors.greyAccent,
                hintText: "Enter Email",
                hintStyle: AppTextStyles.subHeadings,
                border: InputBorder.none,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.transparent, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
                filled: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 30.0),
              ),
            ),
            //end textfield
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: ElevatedButton(
                onPressed: () {
                  if (_emailController.text == "") {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content: Text('Please enter your email!'),
                          );
                        });
                  } else {
                    passwordReset();
                  }
                },
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  // backgroundColor:
                  //     MaterialStateProperty.all<Color>(Colors.blueAccent),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  shadowColor:
                      MaterialStateProperty.all<Color>(Colors.transparent),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Reset Password',
                      style: AppTextStyles.button,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
