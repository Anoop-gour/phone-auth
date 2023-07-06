import 'package:authenticate/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginSignup extends StatelessWidget {
  const LoginSignup({super.key});

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
                  children: [
                    Text('Fashions',style: GoogleFonts.sacramento(color: Colors.white70,fontSize: 50),),
                    Padding(
                      padding: const EdgeInsets.all(49),
                      child: Text('My Life My style',style: TextStyle(color: Colors.white70,),),
                    ),
                  ],
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, 'login');
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 140,vertical: 18),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text('Login',
                          style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    GestureDetector(
                      onTap: (){

                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 130,vertical: 18),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        child: Text('Sign Up',
                          style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,)
                  ],
                ),
              ),

            ],
          ),
        )
    );
  }
}
