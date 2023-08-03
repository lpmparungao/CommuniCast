import 'package:communicast/resources/auth_methods.dart';
import 'package:communicast/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:communicast/constants.dart';

class SettingsCard extends StatelessWidget {
  String? label;
  String? navigator;

  SettingsCard({this.label, this.navigator, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/' + navigator!);
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0)),
        backgroundColor: MaterialStateProperty.all<Color>(AppColors.white),
        overlayColor: MaterialStateProperty.all<Color>(AppColors.greyAccent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
        ),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label!,
            style: AppTextStyles.body,
          ),
          const Icon(
            Icons.arrow_forward_ios,
            color: AppColors.black,
            size: 15.0,
          )
        ],
      ),
    );
  }
}

class SettingsButtons extends StatefulWidget {
  const SettingsButtons({super.key});

  @override
  State<SettingsButtons> createState() => _SettingsButtonsState();
}

class _SettingsButtonsState extends State<SettingsButtons> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SettingsCard(
                label: 'Change Password',
                navigator: 'forgotPassword',
              ),
              Container(height: 10.0, color: AppColors.greyAccent),
              SettingsCard(
                label: 'Terms and Conditions',
                navigator: 'termsAndConditions',
              ),
              SettingsCard(
                label: 'Privacy Policy',
                navigator: 'privacyPolicy',
              ),
              SettingsCard(
                label: 'About CommuniCast',
                navigator: 'aboutCommuniCast',
              ),
              SettingsCard(
                label: 'Contact Us',
                navigator: 'contactUs',
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () async {
              await AuthMethods().signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColors.white),
              overlayColor:
                  MaterialStateProperty.all<Color>(AppColors.greyAccent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
              ),
              shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Log out',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.red,
                  ),
                ),
                const Icon(
                  Icons.logout_rounded,
                  color: Colors.red,
                  size: 15.0,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
