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
  const FontSize.tablet()
      : p1 = 20,
        p2 = 25,
        p3 = 30,
        t1 = 35,
        t2 = 40,
        t3 = 45,
        h1 = 50,
        h2 = 55,
        x1 = 100;

  const FontSize.phone()
      : p1 = 15,
        p2 = 17.5,
        p3 = 20,
        t1 = 22.5,
        t2 = 25,
        t3 = 27.5,
        h1 = 30,
        h2 = 32.5,
        x1 = 55;
}