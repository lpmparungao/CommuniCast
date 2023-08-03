import 'package:flutter/material.dart';
import 'package:communicast/constants.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: const Text('Privacy Policy', style: AppTextStyles.title1),
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
                  'Privacy Policy',
                  style: AppTextStyles.title,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'CommuniCast Inc. values your privacy and is committed to protecting the personal information of its users. We have adopted this Privacy Policy (the “Policy”) to be clear about what data we collect, why we collect it, whom we share it with, how you can access it, and correct it when necessary. \nWe recognize our duty to handle your data in a responsible manner. We do not and will not sell your data to third parties. \nThis Policy applies to the use of CommuniCast ‘s mobile application (“Application”) or (“Services”). Please read it carefully in order to understand when you may provide personal information to us and how CommuniCast uses the personal information provided. By using CommuniCast, you agree to the use of your personal information as described in this Policy. The terms “we”, “us” or “CommuniCast” are each intended as a reference to CommuniCast group.\nTo make this Policy as clear as possible, we have determined the occasions when a customer would potentially share information with CommuniCast. \nWe have then added different sections explaining in more detail how your personal information is used, how and when it might be shared, how you can access and control your personal information, the ways we make sure your information is safe, and how to contact us. ',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Learning about CommuniCast',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'As you learn about CommuniCast, you may voluntarily provide personal information, such as your name and your email address during these interactions. \nWe collect: name, email address, and information provided by cookies or similar technology, such as the amount of time you spend on our Application, the pages you decide to visit, as well as the data and time you are accessing our Application on. \nWhy: We use this personal information for verification upon creating your account. \nLegal basis: necessary for our legitimate interests (improving our services) and yours (responding to your inquiries and allowing you to contact us).\nPlease note that if you refuse to provide us with such information, we will not be able to verify your account and make the CommuniCast’s account.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Using CommuniCast',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Once your account is set up, you will be able to use the CommuniCast through our mobile application. As you use CommuniCast, you and the authorized members of your team may report incidents directly on our platform. In doing so, you may voluntarily provide pictures. Some data such as the date and your GPS location may be captured with permission.\nWe collect: your GPS location, as well as any details you voluntarily enter when reporting an incident on our Services.\nWhy: We collect this information to enhance your experience and let you fully take advantage of all the Services’ features. Automating the collection of your GPS location allows us to simplify the process of reporting an incident for the user. When you report an incident for the first time, your device will ask you whether or not you consent to the application accessing your location. You can always modify your choice through your device settings. \nLegal basis: performance of a contract and necessary for the legitimate interests of the user to take advantage of the features offered by CommuniCast. ',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('HOW WE USE PERSONAL INFORMATION',
                    style: AppTextStyles.body),
                const Text(
                  'CommuniCast uses the data we collect to provide you with the Services we offer, which includes using data to improve and personalize your experience. We also use the data we collect to communicate with you about your account, new features, and other types of updates. We use your data for the following purposes:\nTo ensure we respect the contractual and legal obligations we have towards you (applicable legal basis under the GDPR: contract performance);\nTo offer you the best customer support there is (applicable legal bases under the GDPR: contract performance);\nTo fulfill any legal or regulatory obligations we might have (applicable legal basis under the GDPR: legal obligations);\nTo document activity on our Services in case of a third-party complaint (applicable legal basis under the GDPR: legal obligations) ;\nTo communicate with you, whether for marketing, advertising or account maintenance purposes. For instance, we may contact you by email to notify you of newly available features or updates (applicable legal basis under the GDPR: contract performance, consent).',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('WHOM WE MAY DISCLOSE YOUR INFORMATION TO AND WHY',
                    style: AppTextStyles.body),
                const Text(
                  'We do not and will not sell personal information about our customers. We only disclose your data as authorized in this Policy. We may however share information with parties with whom it might be legally necessary: we may disclose your information if required to do so by law or in the good faith belief that such action is necessary to:\nConform with the law or with any legal proceedings;\nProtect the rights or property of CommuniCast;\nProtect the safety of our Services, our users, and their data.\nPlease note that our Services may link to products or applications of third parties whose privacy practices may differ from CommuniCast’ s. If you provide personal information to any of those parties, your data will be governed by their privacy policies. ',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('YOUR RIGHTS', style: AppTextStyles.body),
                const Text(
                  'Data protection laws give you certain rights in relation to your information. You can, amongst other things,\nAccess: ask if we are processing information and, if we are, request access to personal information in a structured, commonly used technological format. Note, however, that we reserve the right to ask you for additional information to prove your identity;\nAccuracy: we are required to take reasonable steps to ensure that the Personal Information in our possession is accurate, complete, not misleading and up to date;\nCorrection: request that any incomplete or inaccurate personal information we hold be corrected;\nErasure: ask us to delete, destroy or remove personal information in certain circumstances. There are certain exceptions where we may refuse a request for erasure or destruction, for example, where the personal information is required for compliance with law or in connection with claims or required by contract between the parties;\nRestriction: ask us to suspend the processing of certain personal information, for example, to establish its accuracy or the reason for processing it;\nTransfer: request the transfer of certain personal information to another party;\nAutomated decisions: contest any automated decision made where this has a legal or similar significant effect and ask for it to be reconsidered (GDPR only); \nConsent: where we are processing personal information with consent, withdrawal of consent in the circumstances permitted by law; and\nComplaint: make a complaint with a data protection supervisory authority.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('HOW TO ACCESS AND CONTROL YOUR DATA',
                    style: AppTextStyles.body),
                const Text(
                  'You can review, edit or delete your personal data in your CommuniCast account, via our Services, or by contacting us directly at communicastproject@gmail.com. You may withdraw your consent at any time. We will respond to any request as soon as possible. We guarantee a reply within thirty days of you sending in a request.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('WHERE YOUR DATA IS STORED',
                    style: AppTextStyles.body),
                const Text(
                  'Your personal information is currently stored on our database, Firebase. ',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('HOW LONG YOUR DATA WILL BE KEPT FOR',
                    style: AppTextStyles.body),
                const Text(
                  'We will retain all collected information for as long as necessary to provide the Services you have requested, or for other essential purposes such as complying with any legal obligations. As long as your account is active, we will keep your data on our systems. We will also dispose of your data if you decide to withdraw your consent.',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('OUR POLICY TOWARDS CHILDREN',
                    style: AppTextStyles.body),
                const Text(
                  'CommuniCast does not and is not intended to attract children. We do not knowingly solicit personal information from children or send them requests for personal information.\nIf we discover or are notified by a parent or guardian that a child under the age of eighteen has registered on our Services under false pretense, we will cancel the child’s account and will delete any personal information we might have collected in the process. ',
                  style: AppTextStyles.body,
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text('CHANGES AND UPDATES', style: AppTextStyles.body),
                const Text(
                  'CommuniCast may modify or update this Policy without notice, so please review it regularly. Whenever we update our Policy, we will change the date at the very bottom of this Policy. Your continued use of our products and service after any modification to this Policy will constitute your acceptance of such modifications and updates. \n\nIf you have any questions or concerns regarding the use of your personal information, please send us an email at communicastproject@gmail.com\n\n\nUpdated as of 12/21/2022',
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
