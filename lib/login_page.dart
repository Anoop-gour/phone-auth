import 'dart:ui';
import 'package:authenticate/slider/carousel_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Future<FirebaseApp> _firebaseApp;

  final _formKey = GlobalKey<FormState>();
  final _formOtpKey = GlobalKey<FormState>();

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController CountryCode = TextEditingController();
  TextEditingController _otp = TextEditingController();
  var phone;
  bool isLoggedIn =false;
  bool otpSent =false;
  String uid='';
  String _verificationId ='';
  var name = '';

  @override
  void initState() {
    CountryCode.text = '+91';
        super.initState();
    _initializeFirebase();

  }
  void _initializeFirebase() async {
    _firebaseApp = Firebase.initializeApp();
  }
  void _signOut()async{
    await FirebaseAuth.instance.signOut();
    setState(() {
      isLoggedIn = false;
    });
  }


  void _googleSignIn()async{
    final _googleSignIn = GoogleSignIn();
    final signInAccount = await _googleSignIn.signIn();

    final googleAccountAuthentication = await signInAccount?.authentication;
    final credential =
    GoogleAuthProvider.credential(
        accessToken: googleAccountAuthentication?.accessToken,
        idToken: googleAccountAuthentication?.idToken);

    final userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    if(userCredential.user != null){
      print('Google Authentication Done');
      print('${userCredential.user!.displayName} signed in');
      setState(() {
        isLoggedIn = true;
        name = userCredential.user!.displayName!;

      });

    }else{
      print('Unable to sign in');
    }

  }
  void _verifyOTP()async{
    final credential = PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: _otp.text);
    try{
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user != null) {
        setState(() {
          isLoggedIn = true;
          uid = userCredential.user!.uid;
        });
      }
    }
    catch(e){
      print(e);
    }


  }



  void _sendOTP() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: CountryCode.text+phone,
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
    setState(() {
      otpSent = true;
    });
  }


  void verificationCompleted(PhoneAuthCredential credential) async {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isLoggedIn = true;
        uid = FirebaseAuth.instance.currentUser!.uid;
      });
    } else {
      try {
        final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
        if (userCredential.user != null) {
          setState(() {
            isLoggedIn = true;
            uid = userCredential.user!.uid;
          });
        } else {
          print('Failed to sign in');
        }
      } catch (e) {
        print(e);
      }
    }
  }


  void verificationFailed(FirebaseAuthException exception){
    print(exception.message);
    setState(() {
      isLoggedIn = false;
      otpSent = false;
    });
  }

  void codeSent(String verificationId, [int? a]){
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });

  }
  void codeAutoRetrievalTimeout(String verificationId){
    setState(() {
      _verificationId = verificationId;
      otpSent = true;
    });

  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: _firebaseApp,
            builder: (context, snapshot){
             if(snapshot.connectionState == ConnectionState.waiting)return Center(child: CircularProgressIndicator(),);
            return isLoggedIn ?
                Container(
                  child: Column(
                    children: [
                      SizedBox(height: 150,),
                      Icon(Icons.check_circle_outline,color: Colors.green,size: 100,),
                      SizedBox(height: 50,),
                      Text('Successful!',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      Text('You have successfully registered \nin our app and start working in it.',style: TextStyle(fontSize: 18),),

                      SizedBox(height: 240,),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, 'carousel');
                        },

                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 70,vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),

                          ),
                          child: Text('Start Shopping',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),

                )
                :otpSent?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formOtpKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      child: Center(
                        child: Stack(
                          children: [
                            Text('Fashions',style: GoogleFonts.sacramento(color: Colors.black,fontSize: 50),),
                            Padding(
                              padding: const EdgeInsets.only(top: 48,left: 55),
                              child: Text('My Life My style',style: TextStyle(color: Colors.black,),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text('Welcome!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text('please login to continue our app'),
                    SizedBox(height: 60,),
                    Text('OTP',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).focusColor,),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:Row(
                        children: [
                          SizedBox(width: 5,),
                          TextFormField(
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                    border: InputBorder.none
                                ),

                                controller: _otp,
                                keyboardType: TextInputType.phone,

                                validator: (value){
                                  if(value == null  || value.isEmpty){
                                    return 'Please enter OTP';
                                  }else{
                                    return null;
                                  }
                                },
                              ),
                        ],
                      ),
                    ),

                    SizedBox(height: 100,),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: (){
                            if(_formOtpKey.currentState!.validate()){
                              return _verifyOTP();
                            }else{
                              return null;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 110,vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Text('Verify OTP',
                              style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        Expanded(child: Container()),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Container(),),
                        Text('or',style: TextStyle(fontSize: 16),),
                        Expanded(child: Container(),),
                      ],
                    ),

                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: _googleSignIn,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 85,vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Theme.of(context).focusColor)
                            ),
                            child: Text('Login with Google',
                              style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),

                  ],
                ),
              ),
            )
            :Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      child: Center(
                        child: Stack(
                          children: [
                            Text('Fashions',style: GoogleFonts.sacramento(color: Colors.black,fontSize: 50),),
                            Padding(
                              padding: const EdgeInsets.only(top: 48,left: 55),
                              child: Text('My Life My style',style: TextStyle(color: Colors.black,),),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text('Welcome!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text('please login or sign up to continue our app'),
                    SizedBox(height: 60,),
                    Text('Phone',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                    SizedBox(height: 10,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).focusColor,),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 30,
                            child: TextField(
                              controller: CountryCode,
                              decoration: InputDecoration(
                                  border: InputBorder.none
                              ),
                            ),
                          ),

                          Text(
                            '|',style: TextStyle(fontSize: 33,color: Colors.grey),
                          ),
                          SizedBox(width: 8,),
                          Expanded(
                            child: TextFormField(
                              cursorColor: Colors.grey,
                              decoration: InputDecoration(
                                  border: InputBorder.none
                              ),
                              onChanged: (value){
                                phone = value;
                              },
                              controller: phoneNumber,
                              keyboardType: TextInputType.phone,
                              inputFormatters: [LengthLimitingTextInputFormatter(10)],

                              validator: (value){
                                if(value == null  || value.isEmpty){
                                  return 'Please enter number';
                                }else if(!RegExp(r'[0-9]').hasMatch(value)){
                                  return 'Enter a valid number';
                                }else if(value.length!=10){
                                  return 'Enter a valid number';
                                }
                                else{
                                  return null;
                                }
                              },

                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100,),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: (){
                            if(_formKey.currentState!.validate()){
                              return _sendOTP();
                            }else{
                              return null;
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 110,vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30)
                            ),
                            child: Text('Send OTP',
                              style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        Expanded(child: Container()),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Container(),),
                        Text('or',style: TextStyle(fontSize: 16),),
                        Expanded(child: Container(),),
                      ],
                    ),

                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Expanded(child: Container()),
                        GestureDetector(
                          onTap: _googleSignIn,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 85,vertical: 18),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Theme.of(context).focusColor)
                            ),
                            child: Text('Login with Google',
                              style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      // padding: EdgeInsets.only(left:100,top:730),
                        child:Row(
                          children: [
                            Expanded(child: Container(),),
                            Text("Don't have an account?",
                              style: TextStyle(color: Colors.black,fontSize: 14),),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, 'register');
                              } ,
                              child: Text('Sign Up',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(child: Container()),
                          ],
                        )
                    )


                  ],
                ),
              ),
            );
            }

          ),
        ),
      ),
    );
  }
}
