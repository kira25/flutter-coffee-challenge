import 'package:coffee_challenge/models/coffee_model.dart';
import 'package:coffee_challenge/pages/home_page.dart';
import 'package:flutter/material.dart';

class CoffeeConceptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Theme(
      data: ThemeData.light(),
      child: Scaffold(
        body: GestureDetector(

          onVerticalDragUpdate: (details) {
            print(details.primaryDelta);
            if (details.primaryDelta > -20) {
              Navigator.of(context).push(PageRouteBuilder(
                transitionDuration: const Duration(milliseconds: 650),
                pageBuilder: (context, animation, _) {
                  return FadeTransition(
                    opacity: animation,
                    child: HomePage(),
                  );
                },
              ));
            }
          },
          child: Stack(
            children: [
              SizedBox.expand(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA89276), Colors.white])),
                ),
              ),
              Positioned(
                height: size.height * 0.4,
                left: 0,
                right: 0,
                top: size.height * 0.15,
                child: Hero(
                  tag: coffees[6].name,
                  child: Image.asset(
                    coffees[6].image,

                  ),
                ),
              ),
              Positioned(
                height: size.height * 0.7,
                left: 0,
                right: 0,
                bottom: 0,
                child: Hero(
                  tag: coffees[7].name,
                  child: Image.asset(
                    coffees[7].image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                height: size.height ,
                left: 0,
                right: 0,
                bottom: -size.height * 0.8,
                child: Hero(
                  tag: coffees[8].name,
                  child: Image.asset(
                    coffees[8].image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                height: 140,
                left: 0,
                right: 0,
                bottom: size.height * 0.25,
                child: Image.asset('assets/logo.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
