
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:pinput/pinput.dart';




void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key:key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',

      home: MyHomePage(title: 'Flutter Firebase: Authentication'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late Future<FirebaseApp> _firebaseApp;

  @override
  void initState() {
    // TODO: implement initState
    CountryCode.text = "+91";
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

  TextEditingController _phoneNumber = TextEditingController ();
  TextEditingController _otp = TextEditingController();
  TextEditingController CountryCode = TextEditingController();

  var phone = "";


  bool isLoggedIn =false;
  bool otpSent =false;
  String uid='';
  String _verificationId ='';
  var name = '';

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

  final _formKey = GlobalKey<FormState>();
  final _formOtpKey = GlobalKey<FormState>();


  // Widget buildPinPut() {
  //   return Pinput(
  //     onCompleted: (pin) => print(pin),
  //   );
  // }
  //
  // final defaultPinTheme = PinTheme(
  //   width: 56,
  //   height: 56,
  //   textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
  //   decoration: BoxDecoration(
  //     border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
  //     borderRadius: BorderRadius.circular(20),
  //   ),
  // );
  //
  // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  //   border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
  //   borderRadius: BorderRadius.circular(8),
  // );
  //
  // final submittedPinTheme = defaultPinTheme.copyWith(
  //   decoration: defaultPinTheme.decoration?.copyWith(
  //     color: Color.fromRGBO(234, 239, 243, 1),
  //   ),
  // );



  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.tertiary,
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
            child: FutureBuilder(
              future: _firebaseApp,
              builder: (context, snapshot){

                if(snapshot.connectionState == ConnectionState.waiting) return Center( child: CircularProgressIndicator());

                return isLoggedIn
                    ?Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 300),
                      child: Center(
                  child: Column(
                    children: [
                      Text('Welcome $name \nHave a nice day',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ElevatedButton(onPressed: isLoggedIn ? _signOut:_googleSignIn,
                        child: isLoggedIn ? Text('Sign Out'):Text('Sign In with Google'),
                      ),
                    ],
                  ),

                ),
                    )

                :otpSent?
                Form(
                  key: _formOtpKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _otp,
                          keyboardType: TextInputType.number,
                          inputFormatters: [LengthLimitingTextInputFormatter(6)],
                          decoration: InputDecoration(
                            hintText: 'Enter OTP',
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor),),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).indicatorColor),),
                            errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).errorColor),),
                            focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).errorColor),),

                          ),
                          validator: (value){
                            if(value == null  || value.isEmpty){
                              return 'Please enter OTP';
                            }else if(value.length < 6 || !RegExp(r'[0-9]').hasMatch(value)){
                              return 'Enter a valid OTP';
                            }else{
                              return null;
                            }
                          },
                        ),
                    // Pinput(
                    //   defaultPinTheme: defaultPinTheme,
                    //   focusedPinTheme: focusedPinTheme,
                    //   submittedPinTheme: submittedPinTheme,
                    //   validator: (s) {
                    //     return s == '2222' ? null : 'Pin is incorrect';
                    //   },
                    //   pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    //   showCursor: true,
                    //   onCompleted: (pin) => print(pin),
                    // ),

                        SizedBox(height: 10,),
                        ElevatedButton(
                            onPressed:(){
                              if(_formOtpKey.currentState!.validate()){
                                return _verifyOTP();
                              }else{
                                return null;
                              }
                            },
                            child: Text('Verify OTP'))
                      ],

                    ),
                  ),
                )
                :Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50,vertical: 200),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoggedIn ?Text('$name Signed In.'):Text(''),
                        SizedBox(height: 10,),
                        Text('Your Welcome',style: TextStyle(color: Colors.black,fontSize: 28,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                        SizedBox(height: 10,),
                        Container(
                          height: 55,
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).focusColor),
                            borderRadius: BorderRadius.all(Radius.circular(10))
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
                                  controller: _phoneNumber,
                                  keyboardType: TextInputType.phone,
                                  // decoration: InputDecoration(
                                  //   hintText: 'Enter your number',
                                  //   enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).focusColor),),
                                  //   focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).indicatorColor),),
                                  //   errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).errorColor),),
                                  //   focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).errorColor),),

                                //   ),
                                  validator: (value){
                                    if(value == null  || value.isEmpty){
                                      return 'Please enter number';
                                    }else if(!RegExp(r'[0-9]').hasMatch(value)){
                                      return 'Enter a valid number';
                                    }else{
                                      return null;
                                    }
                                },
                                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                //   // inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(16),FilteringTextInputFormatter.allow(RegExp(r'^\+[1-9]\d{0,2}\s?\d{1,14}$'),),
                                //   // ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                            onPressed:(){
                              if(_formKey.currentState!.validate()){
                                return _sendOTP();
                              }else{
                                return null;
                              }
                            },
                            child: Text('Send OTP')),


                        ElevatedButton(
                          onPressed: isLoggedIn ?_signOut:_googleSignIn ,
                          child: isLoggedIn ? Text('Sign Out'):Text('Sign In with Google'),
                        )
                      ],

                    ),
                  ),
                );
              },
            ),
          ),

        ),
      ),
    );
  }
}
