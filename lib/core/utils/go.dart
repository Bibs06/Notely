import 'package:flutter/material.dart';

class Go {
  // Navigate to a page with no animation
  static void to(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
            
        pageBuilder: (context, animation, secondaryAnimation) => page)
    );
  }

  // Navigate to a page with slide animation
  static void toWithAnimation(
      BuildContext context, Widget page, double x, double y) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),
        reverseTransitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => page ,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(x, y);  //right to left 1,0  bottom to top
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  static void toWithPopUntil(BuildContext context, Widget page) {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero, // No transition animation
        reverseTransitionDuration: Duration.zero, // No reverse transition
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child; // No animation, just show the child
        },
      ),
      (route) => false, // Pop all pages in the stack
    );
  }

  

  static void toWithAnimationAndPopUntil(
      BuildContext context, Widget page,double x,double y ) {
    
      // Pop pages until the root and navigate to the new page with animation
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 300),
        reverseTransitionDuration: Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(opacity: animation,child: page,) ,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(x, y);  //right to left 1,0 bottom to top
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
        (route) => false, // Pop all pages in the stack
      );
    
  }
}
