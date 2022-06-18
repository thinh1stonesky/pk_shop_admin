

import 'package:flutter/material.dart';
import 'package:pk_shop_admin/admin/admin_page.dart';
import 'package:pk_shop_admin/admin/list_admin.dart';

import 'helpers/dialog.dart';
import 'helpers/function.dart';
import 'admin/list_admin.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool _isVisible = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  String thongBaoLoi = "";
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Form(
          key: formState,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: SizedBox(
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Spacer(),
                  TextFormField(
                    validator: (value) => ValidateString(value),
                    controller: emailCtrl,
                    decoration: const InputDecoration(
                      label: Text('Email'),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    obscureText: _isVisible ==true ? false : true,
                    validator: (value) => ValidateString(value),
                    controller: passCtrl,
                    decoration: InputDecoration(
                        label: Text('Password'),
                        suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                            icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off)
                        )
                    ),

                  ),
                  const SizedBox(height: 10,),
                  SizedBox(
                    width: size.width * 0.7,
                    child: ElevatedButton(onPressed: (){
                      bool? validate = formState.currentState?.validate();
                      if(validate == true){
                        thongBaoLoi = "";
                        // showSnackBar(context, "signing in ...", 300);
                        if(listAmin.contains(emailCtrl.text) && passCtrl.text == "123" ){
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => const AdminPage(),)
                          , (route) => false);
                        }
                      }
                    },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                          primary: Colors.blue[800],
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.mail),
                            Text('Sign in',style: TextStyle(color: Colors.white),),
                          ],
                        )
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        )
    );
  }

}
