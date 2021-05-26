import 'dart:math';

double _doubleInRange(Random source, num start, num end) =>
    source.nextDouble() * (end - start) + start;
final random = Random();
final coffees = List.generate(_names.length, (index) =>
    Coffee(
        image: 'assets/${index + 1}.png',
        name: _names[index],
        price: _doubleInRange(random, 3, 7)
    ));

class Coffee {
  final double price;
  final String name;
  final String image;

  Coffee({this.price, this.name, this.image});
}

final _names = [
  'Caramale Cold Drink',
  'Iced Coffee Mocaha',
  'Caramelized Pecan Latte',
  'Toffee Nut Latte',
  'Capuchino',
  'Toffee Nut Iced Latte',
  'Americano',
  'Caramel Macchiato',
  'Vietnamese-Stlye Iced Coffee',
  'Black Tea Latte',
  'Classic Irish Coffee',
  'Toffee Nut Crunch Latte'
];

