import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print(user?.uid.toString());
    navigateToHome();
  }
  navigateToHome ()async{
    await Future.delayed(Duration(microseconds: 2000),(){});
    if(user==null) {
      Navigator.pushNamed(context, 'loginsignup');
    }else{
      Navigator.pushNamed(context, 'carousel');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Material(
          child: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset('assets/images/splash.png',fit: BoxFit.fill,color: Colors.black.withOpacity(0.5),colorBlendMode: BlendMode.darken,),
              ),
              Center(
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  children: [
                    Text('Fashions',style: GoogleFonts.sacramento(color: Colors.white70,fontSize: 50),),
                    Padding(
                      padding: const EdgeInsets.all(49),
                      child: Text('My Life My style',style: TextStyle(color: Colors.white70,),),
                    ),

                  ],
                ),
              ),
              
            ],
          ),
        )
    );
  }
}
