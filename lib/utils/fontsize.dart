class FontSize {
  final double p1;
  final double p2;
  final double p3;
  final double t1;
  final double t2;
  final double t3;
  final double h1;
  final double h2;
  final double x1;
  final double x2;
  const FontSize.tablet()
      : p1 = 15,
        p2 = 20,
        p3 = 25,
        t1 = 30,
        t2 = 35,
        t3 = 40,
        h1 = 45,
        h2 = 50,
        x1 = 95,
        x2 = 500;

  const FontSize.phone()
      : p1 = 15,
        p2 = 17.5,
        p3 = 20,
        t1 = 22.5,
        t2 = 25,
        t3 = 27.5,
        h1 = 30,
        h2 = 32.5,
        x1 = 55,
        x2 = 300;
}
