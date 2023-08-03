import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:communicast/constants.dart';
import 'package:communicast/resources/auth_methods.dart';
import 'package:communicast/responsive/mobile_screen_layout.dart';
import 'package:communicast/responsive/responsive_layout.dart';
import 'package:communicast/responsive/web_screen_layout.dart';
import 'package:communicast/screens/login_screen.dart';
import 'package:communicast/utils/colors.dart';
import 'package:communicast/utils/global_variable.dart';
import 'package:communicast/utils/utils.dart';
import 'package:communicast/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _confpassController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;
  bool? checkedValue = false;
  bool _isObscure = false;
  bool _isObscure1 = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    if (_birthdateController.text == "" ||
        _usernameController.text == "" ||
        _emailController.text == "" ||
        _firstnameController.text == "" ||
        _lastnameController.text == "" ||
        _passwordController.text == "" ||
        _bioController.text == "") {
      showSnackBar(context, "Please fill all the fields");
      _isLoading = false;
      return;
    } else {
      if (_passwordController.text != _confpassController.text) {
        showSnackBar(context, "Password doesn't match");
        _isLoading = false;
        return;
      } else if (_confpassController.text == "") {
        showSnackBar(context, "Please confirm your password");
        _isLoading = false;
        return;
      } else {
        if (_image == null) {
          showSnackBar(context, "Please select an image");
          _isLoading = false;
          return;
        } else {
          String res = await AuthMethods().signUpUser(
            email: _emailController.text,
            firstName: _firstnameController.text,
            lastName: _lastnameController.text,
            birthDate: _birthdateController.text,
            password: _passwordController.text,
            username: _usernameController.text,
            bio: _bioController.text,
            file: _image!,
            context: context,
          );
          // if string returned is sucess, user has been created
          if (res == "success") {
            setState(() {
              _isLoading = false;
            });
            // navigate to the login screen
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                duration: const Duration(milliseconds: 500),
                child: const LoginScreen(),
              ),
            );
            // Navigator.of(context).pushReplacement(
            //   MaterialPageRoute(builder: (context) => const LoginScreen()),
            // );
          } else {
            setState(() {
              _isLoading = false;
            });
            // show the error
            showSnackBar(context, res);
          }
        }
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: const EdgeInsets.all(32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 40,
                    child: const Image(
                      image: AssetImage('assets/images/CommuniCast.png'),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Create new account',
                  style: AppTextStyles.title,
                ),
                const Text(
                  'Please fill in the form to create an account',
                  style: AppTextStyles.subHeadings,
                ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: AppColors.greyAccent,
                          )
                        : const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                            backgroundColor: AppColors.greyAccent,
                          ),
                    Positioned(
                      bottom: -10,
                      left: 60,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                          color: Color(0xFF848484),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldInput(
                  hintText: 'Email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                  textCapitalization: TextCapitalization.none,
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 39,
                      child: TextFieldInput(
                        hintText: 'Firstname',
                        textInputType: TextInputType.text,
                        textEditingController: _firstnameController,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 39,
                      child: TextFieldInput(
                        hintText: 'Lastname',
                        textInputType: TextInputType.text,
                        textEditingController: _lastnameController,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 39,
                      child: TextFieldInput(
                        hintText: 'Username',
                        textInputType: TextInputType.text,
                        textEditingController: _usernameController,
                        textCapitalization: TextCapitalization.none,
                      ),
                    ),
                    const SizedBox(
                      width: 14,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 39,
                      child: TextFormField(
                        readOnly: true,
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(1900, 1, 1),
                              maxTime: DateTime(
                                  DateTime.now().year - 18,
                                  DateTime.now().month,
                                  DateTime.now().day), onChanged: (date) {
                            print('change $date');
                          }, onConfirm: (date) {
                            print('confirm $date');
                            setState(() {
                              var dateTime = DateTime.parse(date.toString());
                              var formate1 =
                                  "${dateTime.day}-${dateTime.month}-${dateTime.year}";
                              _birthdateController.text = formate1;
                              //textBirthdate = formate1;
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        controller: _birthdateController,
                        style: AppTextStyles.textFields,
                        decoration: const InputDecoration(
                          fillColor: AppColors.greyAccent,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 30.0),
                          hintText: 'Birthdate',
                          hintStyle: AppTextStyles.subHeadings,
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide:
                                BorderSide(color: Colors.transparent, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          filled: true,
                          suffixIcon: Icon(
                            Icons.calendar_month_rounded,
                            color: Color(0xFF848484),
                          ),
                        ),
                        validator: (var value) {
                          if (value!.isEmpty) {
                            return 'Enter Birthdate';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isObscure,
                  style: AppTextStyles.textFields,
                  decoration: InputDecoration(
                    fillColor: AppColors.greyAccent,
                    filled: true,
                    hintText: 'Enter Password',
                    hintStyle: AppTextStyles.subHeadings,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required!";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _confpassController,
                  obscureText: !_isObscure1,
                  style: AppTextStyles.textFields,
                  decoration: InputDecoration(
                    fillColor: AppColors.greyAccent,
                    filled: true,
                    hintText: 'Confirm Password',
                    hintStyle: AppTextStyles.subHeadings,
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 30.0),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 2),
                    ),
                    suffixIcon: IconButton(
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: Icon(_isObscure1
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure1 = !_isObscure1;
                          });
                        }),
                  ),
                  validator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Required!";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldInput(
                  hintText: 'Bio',
                  textInputType: TextInputType.text,
                  textEditingController: _bioController,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(
                  height: 5,
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.all(0),
                  title: Row(
                    children: [
                      const Text("I agree to the ",
                          style: AppTextStyles.subHeadings),
                      GestureDetector(
                        onTap: () {
                          displayTermsAndConditionDialog();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TermsAndConditions(),
                          //   ),
                          // );
                        },
                        child: Text(
                          "Terms and Conditions",
                          style: AppTextStyles.subHeadings.copyWith(
                            color: AppColors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: checkedValue,
                  onChanged: (newValue) {
                    setState(() {
                      checkedValue = newValue!;
                    });
                  },
                  controlAffinity:
                      ListTileControlAffinity.leading, //  <-- leading Checkbox
                ),
                const SizedBox(
                  height: 5,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (checkedValue == false) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please agree to the terms and conditions',
                            style: AppTextStyles.body,
                          ),
                        ),
                      );
                    } else {
                      signUpUser();
                    }
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30.0)),
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
                    children: [
                      !_isLoading
                          ? const Text(
                              'Sign up',
                              style: AppTextStyles.button,
                            )
                          : const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2,
                              ),
                            ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: const Text('Already have an account?',
                          style: AppTextStyles.subHeadings),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.fade,
                          duration: const Duration(milliseconds: 500),
                          child: const LoginScreen(),
                        ),
                      ),
                      child: Container(
                        child: Text(
                          ' Login.',
                          style: AppTextStyles.subHeadings.copyWith(
                            color: AppColors.blueAccent,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  displayTermsAndConditionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          contentPadding: const EdgeInsets.all(30.0),
          //title:
          content: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                          text: ' Terms and Conditions ',
                          style: AppTextStyles.body.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: 'and ',
                          style: AppTextStyles.body,
                        ),
                        TextSpan(
                          text: ' Privacy Policy.',
                          style: AppTextStyles.body.copyWith(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                          ),
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
                  const SizedBox(
                    height: 20,
                  ),
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
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text(
                          'I Agree',
                          style: AppTextStyles.subHeadings,
                        ),
                        onPressed: () {
                          Navigator.of(context)
                              .pop(false); //Will not exit the App
                          setState(() {
                            checkedValue = true;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //actions: <Widget>[],
        );
      },
    );
  }
}
