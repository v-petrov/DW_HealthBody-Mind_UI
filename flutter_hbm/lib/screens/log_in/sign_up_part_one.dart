import 'package:flutter/material.dart';
import 'package:flutter_hbm/screens/log_in/sign_up_part_two.dart';
import 'package:flutter_hbm/screens/services/authentication_service.dart';
import 'package:flutter_hbm/screens/utils/validators.dart';

class SignUpPartOne extends StatefulWidget {
  const SignUpPartOne({super.key});

  @override
  State<SignUpPartOne> createState() => SignUpPartOneState();
}

class SignUpPartOneState extends State<SignUpPartOne> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  String? firstNameError, lastNameError, emailError, passwordError, confirmPasswordError;
  bool isLoading = false;
  String? errorMessage;

  void validateFirstName(String value) {
    setState(() {
      firstNameError = Validators.validateName(value);
    });
  }

  void validateLastName(String value) {
    setState(() {
      lastNameError = Validators.validateName(value);
    });
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

  void validateConfirmPassword(String value) {
    setState(() {
      confirmPasswordError = Validators.validateConfirmPassword(value, passwordController.text);
    });
  }

  void userDataFirstPart() async {
    validateFirstName(firstNameController.text);
    validateLastName(lastNameController.text);
    validateEmail(emailController.text);
    validatePassword(passwordController.text);
    validateConfirmPassword(confirmPasswordController.text);

    if (firstNameError == null && lastNameError == null && emailError == null &&
        passwordError == null && confirmPasswordError == null) {

      setState(() => isLoading = true);
      try {
        final response = await AuthenticationService.checkEmailExists(emailController.text);
        if (response["exists"] == true) {
          throw Exception("Invalid credentials or unable to proceed.");
        }
        Map<String, dynamic> userData = {
          "firstName": firstNameController.text,
          "lastName": lastNameController.text,
          "email": emailController.text,
          "password": passwordController.text,
        };

        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPartTwo(userData: userData)),
        );
      } catch (e) {
        setState(() {
          errorMessage = e.toString().split(":").last.trim();
        });
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background2.jpg"),
            fit: BoxFit.cover
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(16.0),
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: InputDecoration(
                          labelText: 'First name',
                          border: OutlineInputBorder(),
                          errorText: firstNameError,
                        ),
                        onChanged: validateFirstName,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: InputDecoration(
                          labelText: 'Last name',
                          border: OutlineInputBorder(),
                          errorText: lastNameError
                        ),
                        onChanged: validateLastName,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          errorText: emailError
                        ),
                        onChanged: validateEmail,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          errorText: passwordError
                        ),
                        onChanged: validatePassword,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Confirm password',
                          border: OutlineInputBorder(),
                          errorText: confirmPasswordError
                        ),
                        onChanged: validateConfirmPassword,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          userDataFirstPart();
                        },
                        child: isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text('Continue'),
                      ),
                    ),
                    if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, left: 8.0),
                        child: Text(
                          errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
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