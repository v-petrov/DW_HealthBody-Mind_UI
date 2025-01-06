import 'package:flutter/material.dart';

class SignUpPartOne extends StatelessWidget {
  const SignUpPartOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'First name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Last name',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ),
          SizedBox(height: 10),
          SizedBox(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Confirm password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 150,
            child: ElevatedButton(
              onPressed: null,
              child: Text('Sign Up'),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}