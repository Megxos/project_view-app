import 'package:flutter/material.dart';
import 'package:project_view/ui/colors.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_svg/svg.dart';

class OnBoarding extends StatelessWidget {

  final pages = [
    PageViewModel(
      title: "Be Your Own Project Manager",
      body: "Managing projects has never been this easy",
      image: Center(
        child: SvgPicture.asset("assets/svgs/organizing-projects.svg"),
      ),
      decoration: PageDecoration(
        imageFlex: 2,
        imagePadding: EdgeInsets.zero,
        titleTextStyle: TextStyle().copyWith(color: plainWhite, fontWeight: FontWeight.bold, fontSize: 30),
        bodyTextStyle: TextStyle().copyWith(color: plainWhite),
        boxDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              primaryColor, secondaryColor
            ]
          )
        )
      )
    ),
    PageViewModel(
        title: "Get Helping Hands",
        body: "Let people contribute to your project in bits",
        image: Center(
          child: SvgPicture.asset("assets/svgs/Connecting-teams.svg"),
        ),
        decoration: PageDecoration(
            imageFlex: 2,
            imagePadding: EdgeInsets.zero,
            titleTextStyle: TextStyle().copyWith(color: plainWhite, fontWeight: FontWeight.bold, fontSize: 30),
            bodyTextStyle: TextStyle().copyWith(color: plainWhite),
            boxDecoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      primaryColor, secondaryColor
                    ]
                )
            )
        )
    ),
    PageViewModel(
        title: "All In One",
        body: "Manage all your projects in one place",
        image: Center(
          child: SvgPicture.asset("assets/svgs/app.svg"),
        ),
        decoration: PageDecoration(
            imageFlex: 2,
            imagePadding: EdgeInsets.zero,
            titleTextStyle: TextStyle().copyWith(color: plainWhite, fontWeight: FontWeight.bold, fontSize: 30),
            bodyTextStyle: TextStyle().copyWith(color: plainWhite),
            boxDecoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    colors: [
                      primaryColor, secondaryColor
                    ]
                )
            )
        )
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
          pages: pages,
          globalBackgroundColor: secondaryColor,
          showNextButton: true,
          next: Icon(Icons.arrow_forward_ios, color: plainWhite,),
          showSkipButton: true,
          skip: Text("Skip", style: TextStyle().copyWith(color: plainWhite),),
          dotsDecorator: DotsDecorator(
            color: plainWhite,
            activeSize: Size.square(20),
            activeColor: Colors.pinkAccent,
          ),
          onDone: (){
            Navigator.pushNamed(context, "/signin");
          },
          done: FlatButton(
            child: Icon(
              Icons.done, size: 40,
              color: appAccent,
            ),
          )
      ),
    );
  }
}