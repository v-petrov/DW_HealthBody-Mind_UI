import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/log_in/forgot_password.dart';
import 'package:flutter_hbm/screens/log_in/sign_up_part_one.dart';
import 'package:flutter_hbm/screens/main_page.dart';
import 'package:flutter_hbm/screens/utils/token_helper.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/user_provider.dart';
import '../services/authentication_service.dart';
import '../utils/validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => LoginFormState();
}
class LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? emailError, passwordError;
  bool isLoading = false;

  void loginAuthentication() async {
    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    if (emailError == null && passwordError == null) {
      setState(() => isLoading = true);
      try {
        final response = await AuthenticationService.loginUser(emailController.text, passwordController.text);

        if (response.containsKey("message")) {
          throw Exception(response["message"]);
        }

        String token = response["token"];
        final prefs = await SharedPreferences.getInstance();
        if (!mounted) return;
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        String? oldToken = prefs.getString('authentication_token');
        String? oldUserId = oldToken != null ? TokenHelper.extractUserIdFromToken(oldToken) : null;
        String newUserId = TokenHelper.extractUserIdFromToken(token);
        if (oldUserId != null && oldUserId != newUserId) {
          await prefs.clear();
          await userProvider.clearUserData();
        }
        await prefs.setString('authentication_token', token);

        await userProvider.loadUserProfile(false);
        await userProvider.loadFoodIntakes(DateTime.now().toIso8601String().split("T")[0]);
        await userProvider.loadExerciseData(DateTime.now().toIso8601String().split("T")[0]);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );

      } catch (e) {
        setState(() {
          emailError = e.toString().split(":").last.trim();
        });
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void validateEmail(String value) {
    setState(() {
      emailError = Validators.validateEmail(value);
    });
  }

  void validatePassword(String value) {
    setState(() {
      passwordError = Validators.validatePassword(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Health Body&Mind',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Divider(
                      color: Colors.black,
                      thickness: 1.5,
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          errorText: emailError,
                        ),
                        onChanged: validateEmail,
                      ),
                    ),
                    SizedBox(height: 20),

                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          errorText: passwordError,
                        ),
                        onChanged: validatePassword,
                      ),
                    ),
                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPassword()),
                          );
                        },
                        child: Text(
                          'Forgot password',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: isLoading ? null : loginAuthentication,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Log In'),
                    ),
                    SizedBox(height: 10),

                    Text('or'),
                    SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPartOne()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(150, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}