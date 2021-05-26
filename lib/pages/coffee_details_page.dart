import 'package:coffee_challenge/models/coffee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum CoffeeSize { Small, Medium, Big }

enum CoffeeTemperature { Warm, Ice }

const _duration = Duration(milliseconds: 200);

class CoffeeDetailsPage extends StatefulWidget {
  final Coffee coffee;

  const CoffeeDetailsPage({Key key, this.coffee}) : super(key: key);

  @override
  _CoffeeDetailsPageState createState() => _CoffeeDetailsPageState();
}

class _CoffeeDetailsPageState extends State<CoffeeDetailsPage> {
  CoffeeSize _selectedCoffeeSize;
  CoffeeTemperature _selectedCoffeeTemperature;
  PageController _pageController;

  void _changeCoffeeSize(CoffeeSize coffeeSize) {
    _pageController.animateToPage(coffeeSize.index,
        duration: _duration, curve: Curves.fastOutSlowIn);
    setState(() {
      _selectedCoffeeSize = coffeeSize;
    });
  }

  void _changeCoffeeTemperature(CoffeeTemperature coffeeTemperature) {
    setState(() {
      _selectedCoffeeTemperature = coffeeTemperature;
    });
  }

  double _getSizePricePercent({CoffeeSize coffeeSize = CoffeeSize.Medium}) {
    final pricePercent = {
      '0': 0.8,
      '1': 1.0,
      '2': 1.2,
    };
    var price = pricePercent[coffeeSize.index.toString()];
    return price;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedCoffeeTemperature = CoffeeTemperature.Warm;
    _selectedCoffeeSize = CoffeeSize.Medium;
    _pageController = PageController(initialPage: 2);
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
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
             //
              //COFFEE NAME
              //
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                child: Hero(
                  tag: "text_${widget.coffee.name}",
                  child: Material(
                    child: Text(
                      widget.coffee.name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),

              Expanded(
                child: Stack(
                  children: [
                    //
                    //COFFEE IMAGE
                    //
                    Positioned.fill(
                        left: size.width * 0.2,
                        right: size.width * 0.2,
                        bottom: size.height * 0.3,

                        child: Hero(
                            tag: widget.coffee.name,
                            child: PageView(
                              physics: NeverScrollableScrollPhysics(),
                              controller: _pageController,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 80),
                                  child: Image.asset(
                                    widget.coffee.image,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 40),
                                  child: Image.asset(
                                    widget.coffee.image,
                                  ),
                                ),
                                Image.asset(
                                  widget.coffee.image,
                                )
                              ],
                            ))),
                    //
                    //COFFEE PRICES
                    //
                    Positioned(
                      left: size.width * 0.3,
                      right: size.width * 0.3,
                      bottom: size.height * 0.35,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 1.0, end: 0.0),
                        builder: (context, value, child) {
                          return Transform.translate(
                              offset: Offset(-100 * value, 240 * value),
                              child: child);
                        },
                        duration: _duration,
                        child: TweenAnimationBuilder<double>(
                          duration: _duration,
                          tween: Tween(
                              begin: 0.0,
                              end: _selectedCoffeeSize != CoffeeSize.Medium
                                  ? _getSizePricePercent(
                                      coffeeSize: _selectedCoffeeSize)
                                  : 1.0),
                          builder: (context, value, _) {
                            return Transform.scale(
                              scale: value,
                              child: Text(
                                '\$ ${(widget.coffee.price * value).toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      BoxShadow(
                                          color: Colors.black45,
                                          blurRadius: 30,
                                          spreadRadius: 20)
                                    ]),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    //
                    //COFFEE SIZES
                    //
                    Positioned(
                        left: size.width * 0.2,
                        right: size.width * 0.2,
                        bottom: size.height * 0.15,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:
                              List.generate(CoffeeSize.values.length, (index) {
                            final coffeeSize = CoffeeSize.values[index];

                            return _CoffeSizeOption(
                              coffeSize: coffeeSize,
                              isSelected: (coffeeSize == _selectedCoffeeSize),
                              onTap: () => _changeCoffeeSize(coffeeSize),
                            );
                          }),
                        )),

                    Positioned(
                        bottom: 20,
                        child: Container(
                          width: size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: List.generate(
                                CoffeeTemperature.values.length, (index) {
                              final coffeeTemperature =
                                  CoffeeTemperature.values[index];
                              return _CoffeeTemperatureOption(
                                coffeeTemperature: coffeeTemperature,
                                isSelected: (coffeeTemperature ==
                                    _selectedCoffeeTemperature),
                                onTap: () =>
                                    _changeCoffeeTemperature(coffeeTemperature),
                              );
                            }),
                          ),
                        )),
                    Align(
                      alignment: Alignment(.5, -.9),
                      //-----------------------------
                      // Add Button Animated
                      //-----------------------------
                      child: TweenAnimationBuilder(
                        duration: const Duration(milliseconds: 600),
                        tween: Tween(begin: 1.0, end: 0.0),
                        curve: Curves.fastOutSlowIn,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset((size.width * .3) * value, 0),
                            child: Transform.rotate(
                              angle: 4.28 * value,
                              child: child,
                            ),
                          );
                        },
                        child: FloatingActionButton(
                          onPressed: () {},
                          mini: true,
                          elevation: 10,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.brown[700],
                          child: Icon(Icons.add),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CoffeeTemperatureOption extends StatelessWidget {
  final CoffeeTemperature coffeeTemperature;
  final bool isSelected;
  final VoidCallback onTap;

  const _CoffeeTemperatureOption(
      {Key key, this.coffeeTemperature, this.isSelected, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Opacity(
        opacity: isSelected ? 1.0 : 0.5,
        child: coffeeTemperature == CoffeeTemperature.Ice
            ? Text(
                'Cold | Ice',
                style: Theme.of(context).textTheme.headline1,
              )
            : Text('Hot | Warm', style: Theme.of(context).textTheme.headline1),
      ),
    );
  }
}

class _CoffeSizeOption extends StatelessWidget {
  final CoffeeSize coffeSize;
  final bool isSelected;
  final VoidCallback onTap;

  const _CoffeSizeOption({this.coffeSize, this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    final label = coffeSize.toString().split('.')[1][0].toLowerCase();
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isSelected
                      ? [Colors.brown, Colors.orange]
                      : [Colors.grey[300], Colors.grey[300]])
              .createShader(bounds),
          child: SvgPicture.asset(
            'assets/svg/$label-coffee-cup.svg',
            height: 45,
            color: Colors.white,
          )),
    );
  }
}
