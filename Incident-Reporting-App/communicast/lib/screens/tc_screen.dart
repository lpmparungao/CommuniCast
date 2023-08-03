import 'package:flutter/material.dart';
import 'package:communicast/constants.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key});

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Terms and Conditions', style: AppTextStyles.title1),
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
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text:
                        'By creating an account, you acknowledge that you have reviewed and agree to be bound by CommuniCast’s ',
                    style: AppTextStyles.body.copyWith(),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Terms and Conditions',
                        style: AppTextStyles.body.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: ' and ',
                        style: AppTextStyles.body,
                      ),
                      TextSpan(
                        text: ' Privacy Policy',
                        style: AppTextStyles.body.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: '.',
                        style: AppTextStyles.body,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Terms and Conditions',
                  style: AppTextStyles.title,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'General',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Welcome to CommuniCast. Please read these terms and conditions (“Terms” or “Agreement”) prior to completing the registration for an account with CommuniCast. The following Terms shall govern how you may access and use the CommuniCast incident reporting mobile application (the “Application”) or (the “Services”). By registering, you accept and agree to be legally bound by these Terms. You further acknowledge and agree that you have read and understand CommuniCast’s Privacy Policy. Please also read the Privacy Policy of CommuniCast. These Terms shall be effective, valid, and binding from the time of your agreement which is from the time of your registering for an account. The terms “CommuniCast”, “we”, “us”, “our” and “ours” refer to CommuniCast group. ',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'User registration',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Registration: In order to use CommuniCast’s Application, you will need to sign up for an account. You must provide CommuniCast with accurate, complete, and current information.\nYou must be at least eighteen (18) years of age to register for a Communicast account. By registering, you represent and warrant that you are at least eighteen (18) years of age and have the legal capacity to agree with these Terms. \nPassword: You agree and understand that you are responsible for maintaining the confidentiality of your user account password. CommuniCast will not be liable for any costs, damages or expenses out of failure by you to maintain security of your account password.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'User Input Data & Rights Granted',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Our Services allow you to input a wide variety of data and materials when reporting an incident. You are responsible for inputting accurate, complete, and up-to-date data when using our Services. \nBy submitting data, passwords, usernames, materials and other content to CommuniCast through your use of our Services, you are licensing that content to us. We may use and store the content in accordance with this Agreement and our Privacy Policy.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'By using our Services, you agree that:',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'You will only use our Services for lawful purposes. You will not use our Services for any illegal or immoral purposes, including but not limited to pornography, drug use, gambling or prostitution, or any other purpose reasonably likely to reflect negatively on CommuniCast.\nYou will not post any (i) information which is incomplete, false, inaccurate or not your own, (ii) trade secrets or material that is copyrighted or otherwise owned by a third party unless you have a valid license from the owner which permits you to post it, (iii) material that infringes on any other intellectual property, privacy or publicity right of another, (iv) advertisement, promotional materials or solicitation related to any product or service that is competitive with CommuniCast products or services or (v) software or programs which contain any harmful code, including, but not limited to, viruses, worms, time bombs or Trojan horses.\nYou are responsible for your own communications, including the upload, transmission and posting of information, and are responsible for the consequences of their posting on or through our Services.\nYou will not impersonate another person.\nYou will not engage in or encourage conduct that would constitute a criminal offence, give rise to civil liability or otherwise violate any city, provincial, state, national or international law or regulation, or which fails to comply with accepted Internet protocol.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Modifications',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'CommuniCast reserves the right to modify these Terms of Use without notice and any modifications are effective when they are posted here and apply to all access and use of the Application thereafter. Your continued use of this Application following the posting of revised Terms of Use means that you accept and agree to the changes. You are expected to check this page from time to time so you are aware of any changes to the Terms of Use.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Payment Terms',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Any fees that CommuniCast may charge you for the use of our Services are due immediately and are non-refundable. This policy shall apply at all times regardless of your decisions to terminate your usage, our decision to terminate your usage, disruption caused to the Services, either planned, accidental or intentional, or any reason whatsoever.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Intellectual Property',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Copyright: The contents of the Services, including but not limited to text, graphics, images, logos, button icons, photographs, editorial content, notices, software, and other material, are protected under applicable copyright laws. The contents of the Services belong to CommuniCast. CommuniCast grants you the right to view and use the Services subject to these terms.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Access and interference',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'You agree that you will not:\nUse any robot, spider, scraper, deep link or other similar automated data gathering or extraction tools, program, algorithm or methodology to access, acquire, copy or monitor the Application, without CommuniCast’s express written consent, which may be withheld in CommuniCast’s sole discretion;\nUse or attempt to use any engine, software, tool, agent, or other device or mechanism (including without limitation browsers, spiders, robots, avatars or intelligent agents) to navigate or search the Application, other than the search engines and search agents available through the Application.\nPost or transmit any file which contains viruses, worms, Trojan horses or any other contaminating or destructive features, or that otherwise interfere with the proper working of the Application;\nAttempt to decipher, decompile, disassemble, or reverse-engineer any of the software comprising or in any way making up a part of the Application; or\nAttempt to gain an unauthorized access to any portion of the Application or its related systems or networks; and\nAttempt to probe, scan or test the vulnerability of a system or network or to breach security or authentication measures.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Internet Delays & Modifications',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'The Services may be subject to limitations, delays, and other problems inherent in the use of the internet and electronic communications. CommuniCast is not responsible for any delays, delivery failures, or other damages of whatsoever nature resulting from such problems. You agree that CommuniCast shall not be liable to you or to any third party for any modification, suspensions, or discontinuance of the Services.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'User Input Data Accuracy',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'The Services contain user input data.  Because of the nature of such data, CommuniCast does not guarantee that user input data will always be up to date or error-free. While CommuniCast will make reasonable efforts to provide the date and time on which the data was last updated, CommuniCast will not be responsible for any damages of whatsoever nature resulting from user input data or a delay in updating said user input data.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Indemnification',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'By entering into this Agreement and using the Services, you agree that you shall defend, indemnify and hold CommuniCast harmless from and against any and all claims, costs, damages, losses, liabilities and expenses (including  attorney’s fees and costs) arising out of or in connection with: (a) your violation or breach of any term of this Agreement or any applicable law or regulation, whether or not referenced herein; (b) your violation of any rights of any third party, or (c) your use or misuse of the Services, except in each case solely to the extent any of the foregoing arises directly from the gross negligence or willful misconduct of CommuniCast.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'No warranty',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'CommuniCast works to protect the Services and keep them error-free, but you agree to use the Services at your own risk. We provide the Services “as is” and “as available” without any representation or warranty, expressed, implied or statutory, not expressly stated in these terms and conditions. In addition, neither CommuniCast, its affiliates or their respective employees, agents, third party content providers or contributors make any representation or warranty as to the reliability, pertinence, quality, suitability or availability of the Services or that the services will be uninterrupted or error free.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Termination',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'CommuniCast may at any time, terminate this Agreement, terminate your account and suspend or deny, in its sole discretion, your access to all or any portion of the Application without notice if: \nyou have breached any provision of this Agreement or any applicable law or intend to breach any provision; \nCommuniCast is required to do so by law; \nCommuniCast is transitioning to no longer providing services to persons in the country in which you are resident or from which you use the Application;\nYour conduct has impacted CommuniCast’s name or reputation\nYou agree that CommuniCast shall not be liable to you or any third party for any termination of your access to the Website or Application.\n\nIf you wish to terminate this Agreement, you may cease all use of the Application and request CommuniCast to cancel your account via email to communicastproject@gmail.com.\n\n\nUpdated as of 12/21/2022',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
