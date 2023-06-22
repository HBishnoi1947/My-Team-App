import 'package:flutter/material.dart';
import 'package:my_team/pages/login_page.dart';
import 'package:my_team/pages/register_page.dart';

class FirstBackgroundPage extends StatefulWidget {
  const FirstBackgroundPage({super.key});

  @override
  State<FirstBackgroundPage> createState() => _FirstBackgroundPageState();
}

class _FirstBackgroundPageState extends State<FirstBackgroundPage>
    with TickerProviderStateMixin {
      int timeInMilliSeconds = 800;
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: timeInMilliSeconds*2));
  late final Animation<Offset> _animationSlide =
      Tween<Offset>(begin: Offset(0.30, 0.30), end: Offset(-0.30, -0.30)).animate(_controller);
      
  bool loginRegister = true;
  double x=0.30;
  @override
  void initState() {
    super.initState();
    _animationSlide.addListener(() {
      setState(() {
        x=_animationSlide.value.dx;
      });
    });
    _controller.forward(from: .5);
  }

  @override
  void dispose() {
    _animationSlide.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  towardsLogin() async{
    _animationSlide.addListener(() {
      setState(() {
        x=_animationSlide.value.dx;
      });
    });
    _controller.forward();
    await Future.delayed(Duration(milliseconds: timeInMilliSeconds));
    setState(() {
      loginRegister = true;
    });
  }

  towardsRegister() async{
    _animationSlide.addListener(() {
      setState(() {
        x=_animationSlide.value.dx;
      });
    });
    _controller.reverse();
    await Future.delayed(Duration(milliseconds: timeInMilliSeconds));
    setState(() {
      loginRegister = false;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: const AssetImage("assets/basketball_stadium.jpg"),
          fit: BoxFit.cover,
          alignment: Alignment(x,0),
        )),
        child: loginRegister
            ? LoginPage(
                towardsRegister: towardsRegister, timeInMilliSeconds: timeInMilliSeconds,
              )
            : RegisterPage(
                towardsLogin: towardsLogin, timeInMilliSeconds: timeInMilliSeconds,
              ));
  }
}
