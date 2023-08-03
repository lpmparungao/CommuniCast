import 'package:flutter/material.dart';
import 'package:communicast/constants.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('About CommuniCast', style: AppTextStyles.title1),
        backgroundColor: AppColors.white,
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
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'About this App',
                  style: AppTextStyles.title,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'CommuniCast is an app that allows you to report incidents and hazards, then cast them to the general public. CommuniCast enables people to quickly take a photo, input details and report what has occurred in real-time in the field as the incident occurred. It is important that people have the tool to report incidents themselves specially when they witness it themselves.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Record the details of the incident you are involved in or have witnessed via your phone using this app.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'See all reported incidents in either feed or map feature of this app to be aware of all the incidents that occurred specially near your area.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Get notified when another user reported an incident.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Incident reports are differentiated using different codes:',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                Text(
                  'Code RED:',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Fire/Smoke Alarm, or Actual Fire Condition',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                Text(
                  'Code AMBER:',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Child or Infant Missing, or Abducted',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                Text(
                  'Code BLUE:',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Medical Emergency',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                Text(
                  'Code GREEN:',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Hazardous Materials Incident and Evacuate Announced Location',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                Text(
                  'Code BLACK:',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Weather Warning',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'CommuniCast is easy to use and ideal in the field.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'About CommuniCast Inc.',
                  style: AppTextStyles.title,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'CommuniCast Inc. is a software development team from Polytechnic University of the Philippines – Manila. CommuniCast encompasses a team of passionate and talented Computer Engineering students with strong design and programming skills and are focused on crafting and developing mobile applications that are easy to use and useful to the users. CommuniCast offers a wide variety of services including mobile development, web development, and software development. Our mission is to provide high quality software service going beyond client expectations.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
