import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:fluttertest/feature/product_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'login_notifier.dart';

class Login extends ConsumerWidget{
  const Login({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();


    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 500,
          height: 400,
          child: Card(

            child: Column(
              children: [
                Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      hintText: 'Email'
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),),
                Padding(padding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                  child: TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: 'Password'
                    ),
                  ),),
               Padding(padding: EdgeInsets.symmetric(vertical: 50,horizontal: 15),
                 child:  ElevatedButton(
                   onPressed: () async {
                     final emailText = email.text.toString();
                     final passwordText = password.text.toString();

                     await ref.read(loginNotifierProvider.notifier).login(emailText, passwordText).then((value){
                       if(value!=""){
                         WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                           Navigator.push(
                               context,
                               MaterialPageRoute(
                                   builder: (context) => ProductScreen()));
                         });

                       }else{
                         Fluttertoast.showToast(
                           msg: '$value',
                           toastLength: Toast.LENGTH_SHORT,
                           gravity: ToastGravity.CENTER,
                           timeInSecForIosWeb: 1,
                         );
                       }
                     });

                   },
                   child: Text('Login'),

                 ),),


              ],
            ),
          ),
        ),
      )
    );

  }

}

