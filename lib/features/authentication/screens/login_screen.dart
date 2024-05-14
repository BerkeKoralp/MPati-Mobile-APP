import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mpati_pet_care/core/common/login_email_button.dart';
import 'package:mpati_pet_care/core/constants/constants.dart';
import 'package:mpati_pet_care/features/authentication/controller/auth_controller.dart';
import 'package:mpati_pet_care/theme/palette.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/sign_in_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String groupValue = ref.watch(typeOfAccountProvider);

    return Scaffold(

      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(Constants.logoPath,height: 100,),
            ),
            const SizedBox(height: 30,),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Mpati',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      key: Key('email-field'), // Key added
                      autofocus: true,
                      focusNode: emailFocusNode,
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email Address',
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextField(
                      key: Key('password-field'), // Key added
                      obscureText: true,
                      focusNode: passwordFocusNode,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //forgot password screen
                    },
                    child: const Text(
                      'Forgot Password',
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      RadioListTile<String>(
                        title: const Text('Owner'),
                        value: 'owner',
                        groupValue: groupValue,
                        onChanged: (value) {
                          ref.read(typeOfAccountProvider.notifier).update((state) => value!) ;
                        },
                      ),
                      RadioListTile<String>(
                        title: const Text('Caretaker'),
                        value: 'caretaker',
                        groupValue: groupValue,
                        onChanged: (value) {
                          ref.read(typeOfAccountProvider.notifier).update((state) => value!);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('Selected Role: $groupValue',
                          style:TextStyle(color: Palette.brown1) ,),
                      ),
                    ],
                  )
                 ,
                 LoginEmailButton(emailController.text, passwordController.text),
                  //CREATE ACCOUNT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Does not have account?',
                      style: TextStyle(color: Palette.brown1),),
                      TextButton(
                        child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20
                          ,fontWeight: FontWeight.bold,
                          color: Palette.nutellaBrown,fontFamily: 'Acme'),
                        ),
                        onPressed: () =>  Routemaster.of(context).push('/create-account') ,
                      )
                    ],
                  ),
                  //Google Sign in
                  const SignInButton()
                ],
              ),
            ),
            //WITH GOOGLE
          ],
        ),
      ),
    );
  }
}

