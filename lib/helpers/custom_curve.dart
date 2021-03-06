import 'package:flutter/material.dart';
import 'dart:math' as math;


class ValleyQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return 4 * math.pow(t - 0.5, 2);
  }
}

class PeakQuadraticCurve extends Curve {
  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    return -15 * math.pow(t, 2) + 15 * t + 1;
  }
}
