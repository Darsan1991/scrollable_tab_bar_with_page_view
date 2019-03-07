import 'dart:ui';

double lerb(double from, double to, double time) {
  return from + (to - from) * time;
}

lerbColor(Color from, Color to, double time) {
  return Color.fromARGB(
    lerb(from.alpha.toDouble(), to.alpha.toDouble(), time).toInt(),
    lerb(from.red.toDouble(), to.red.toDouble(), time).toInt(),
    lerb(from.green.toDouble(), to.green.toDouble(), time).toInt(),
    lerb(from.blue.toDouble(), to.blue.toDouble(), time).toInt(),
  );
}
