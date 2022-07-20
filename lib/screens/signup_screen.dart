import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/ressources/auth_methods.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({ Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text.toLowerCase(),
      bio: _captalize(_bioController.text),
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if(res != 'success') {
      showSnackBar(res, context);
    }else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const ResponsiveLayout(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
        ),
      );
    }
  }

  String _captalize(String text) {
    return text.substring(0,1).toUpperCase() + text.substring(1,text.length);
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    //SVG image
                    SvgPicture.asset(
                      'assets/logo_instagram.svg',
                      color: primaryColor,
                      height: 64,
                    ),
                    const SizedBox(height: 64),
                    //circular widget to accept and show our selected file
                    Stack(
                      children: [
                        _image != null ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                            : const CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage(
                              'assets/default_profile_picture.jpg'
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            onPressed: selectImage,
                            icon: const Icon(
                                Icons.add_a_photo
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //text field input for username
                    TextFieldInput(
                      textInputType: TextInputType.text,
                      textEditingController: _usernameController,
                      hintText: 'Enter your username',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //text field input for email
                    TextFieldInput(
                      textInputType: TextInputType.emailAddress,
                      textEditingController: _emailController,
                      hintText: 'Enter your email',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //text field input for password
                    TextFieldInput(
                      textInputType: TextInputType.text,
                      textEditingController: _passwordController,
                      hintText: 'Enter your password',
                      isPass: true,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFieldInput(
                      textInputType: TextInputType.text,
                      textEditingController: _bioController,
                      hintText: 'Enter your bio',
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    //button login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width-64,
                          child:
                          RawMaterialButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4),)
                            ),
                            fillColor: blueColor,
                            onPressed: signUpUser,
                            child: _isLoading
                                ? const Center(child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                            )
                                : const Text(
                              'Log in',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    //Transitioning to sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child:
                          RawMaterialButton(
                            onPressed: (){},
                            child: const Text("Don't have a account?"),
                          ),
                        ),
                        SizedBox(
                          child:
                          RawMaterialButton(
                            onPressed: navigateToLogin,
                            child: const Text(
                              'Login.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
        )
    );
  }
}