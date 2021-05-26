import 'package:coffee_challenge/models/coffee_model.dart';
import 'package:coffee_challenge/pages/coffee_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _duration = Duration(milliseconds: 200);
const _initialPage = 8.0;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageCoffeeController =
      PageController(viewportFraction: 0.35, initialPage: _initialPage.toInt());
  double _currentPage = _initialPage;
  final _pageTextController = PageController(initialPage: _initialPage.toInt());
  double _textPage = _initialPage;
  bool finalPage = false;

  void _textScrollListener() {
    _textPage = _currentPage;
  }

  void _coffeeControlListener() {
    setState(() {
      _currentPage = _pageCoffeeController.page;
      if (_currentPage > 11) {
        finalPage = true;
      } else {
        finalPage = false;
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageCoffeeController.addListener(_coffeeControlListener);
    _pageTextController.addListener(_textScrollListener);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(
            color: Theme.of(context).iconTheme.color,
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.shopping_bag_outlined,
                color: Theme.of(context).iconTheme.color,
              ),
            )
          ],
        ),
        body: Stack(
          children: [
            //FONDO
            Positioned(
              left: 20,
              right: 20,
              bottom: -size.height * 0.22,
              height: size.height * 0.3,
              child: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      color: Colors.brown, blurRadius: 90, spreadRadius: 45)
                ]),
              ),
            ),
            //COFFEES
            Transform.scale(
              scale: 1.6,
              alignment: Alignment.bottomCenter,
              child: PageView.builder(
                onPageChanged: (value) {
                  if (value < coffees.length) {
                    _pageTextController.animateToPage(value,
                        duration: _duration, curve: Curves.easeInOut);
                  }
                },
                controller: _pageCoffeeController,
                scrollDirection: Axis.vertical,
                physics: finalPage
                    ? NeverScrollableScrollPhysics()
                    : AlwaysScrollableScrollPhysics(),
                itemCount: coffees.length + 1,
                itemBuilder: (context, index) {
                  print(_currentPage);
                  print(index);
                  if (index == 0) {
                    return const SizedBox.shrink();
                  }

                  final coffee = coffees[index - 1];
                  //El primer elemento no se ve
                  final result = _currentPage - index + 1;
                  final value = -0.4 * result + 1;
                  final opacity = value.clamp(0.0, 1.0);
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 650),
                        pageBuilder: (context, animation, _) {
                          return FadeTransition(
                            opacity: animation,
                            child: CoffeeDetailsPage(
                              coffee: coffee,
                            ),
                          );
                        },
                      ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..translate(
                                0.0, size.height / 2.6 * (1 - value).abs())
                            ..scale(value),
                          child: Opacity(
                              opacity: opacity,
                              child: Hero(
                                tag: coffee.name,
                                child: Image.asset(
                                  coffee.image,
                                  fit: BoxFit.fitHeight,
                                ),
                              ))),
                    ),
                  );
                },
              ),
            ),
            //NOMBRE DEL CAFE
            Positioned(
                left: 0,
                top: 0,
                right: 0,
                height: 100,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: 0.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                        offset: Offset(0, -100 * value), child: child);
                  },
                  duration: _duration,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageTextController,
                          itemCount: coffees.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final opacity =
                                (1 - (index - _textPage).abs()).clamp(0.0, 1.0);
                            return Opacity(
                                opacity: opacity,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.2),
                                  child: Hero(
                                    tag: "text_${coffees[index].name}",
                                    child: Material(
                                      child: Text(
                                        coffees[index].name,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      //
                      //COFFEE PRICE
                      //
                      AnimatedSwitcher(
                        duration: _duration,
                        child: Text(
                          '\$${coffees[_currentPage.toInt()].price.toStringAsFixed(2)}',
                          key: Key(coffees[_currentPage.toInt()].name),
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
