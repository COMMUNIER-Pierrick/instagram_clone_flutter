import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/ressources/auth_methods.dart';
import 'package:instagram_clone/screens/signup_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/widgets/text_field_input.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<String> loginUser() async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await AuthMethods().loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        return "success";
      } else {
        setState(() {
          _isLoading = false;
        });
        return "failed";
      }
    }catch(e){
      _showSnackBar(e.toString());
      rethrow;
    }
  }

  void navigateToSignup() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  void _navigatorToScreenLayout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
        const ResponsiveLayout(
          mobileScreenLayout: MobileScreenLayout(),
          webScreenLayout: WebScreenLayout(),
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 3)
                : const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                //SVG image
                SvgPicture.asset(
                  'assets/logo_instagram.svg',
                  colorFilter: const ColorFilter.mode(
                    primaryColor,
                    BlendMode.srcIn,
                  ),
                  height: 64,
                ),
                const SizedBox(height: 60),
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
                //button login
                InkWell(
                  onTap: () async {
                    final success = await loginUser();
                    if (success == "success") {
                      _navigatorToScreenLayout();
                    } else {
                      _showSnackBar('E-mail ou mot de passe incorrect.');
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: blueColor,
                    ),
                    child: !_isLoading
                        ? const Text(
                      'Log in',
                    )
                        : const CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Flexible(
                  flex: 2,
                  child: Container(),
                ),
                //Transitioning to sign up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Dont have an account?',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          ' Signup.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
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
    );
  }
}
