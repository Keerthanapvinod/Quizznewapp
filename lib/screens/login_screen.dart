import 'package:flutter/material.dart';
import 'package:quizzapp/data/login_data.dart';
import 'package:quizzapp/models/login.dart';
import 'package:quizzapp/screens/quizz_screen.dart';
import 'package:collection/collection.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _loginId;
  String? _password;

  @override
  void dispose() {
   
    _loginIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login',style: TextStyle(fontSize: 20.sp),),
        centerTitle: true, 
      ),
      body: Padding(
        padding:  EdgeInsets.all(1.h),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Login ID Input
              Padding(
                padding:  EdgeInsets.only(bottom: 2.h),
                child: TextFormField(
                  controller: _loginIdController,
                  decoration: InputDecoration(
                    labelText: 'Login ID',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.w),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Login ID';
                    }
                    return null;
                  },
                  onSaved: (value) => _loginId = value,
                ),
              ),
              

              // Password Input
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value,
              ),
             

              // Login Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 3.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.w),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                   
                    final matchingLogin = logins.firstWhereOrNull(
                      (login) =>
                          login.loginId == _loginId && login.password == _password,
                    );

                    if (matchingLogin != null) {
                     
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => QuizzScreen()),
                      );
                    } else {
                    
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invalid login credentials')),
                      );
                    }
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
