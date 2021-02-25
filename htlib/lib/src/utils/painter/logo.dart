import 'package:flutter/material.dart';
import 'package:htlib/_internal/components/spacing.dart';
import 'package:htlib/styles.dart';

class LogoIndicator extends StatefulWidget {
  final double size;
  final double padding;

  const LogoIndicator({Key key, this.size = 300.0, this.padding = 8.0})
      : super(key: key);

  @override
  _LogoIndicatorState createState() => _LogoIndicatorState();
}

class _LogoIndicatorState extends State<LogoIndicator> {
  double onEnd = 1.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            duration: Durations.slow,
            curve: Curves.ease,
            tween: Tween<double>(begin: 0.8, end: onEnd),
            onEnd: () =>
                setState(() => (onEnd == 1.0) ? onEnd = 0.8 : onEnd = 1.0),
            builder: (context, value, child) => Logo(size: widget.size * value),
          ),
          VSpace(widget.padding ?? Insets.l + Insets.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 8,
              width: widget.size * 0.7,
              child: LinearProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  final double size;
  final Widget constrainChild;

  const Logo({Key key, this.size = 30, this.constrainChild}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ColorLogoPainter(),
      size: (constrainChild == null) ? Size(size, size) : Size.zero,
      willChange: false,
      child: constrainChild,
    );
  }
}

class _ColorLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9103027, size.height * 0.7324004);
    path_0.lineTo(size.width * 0.1860117, size.height * 0.7324004);
    path_0.cubicTo(
        size.width * 0.1189863,
        size.height * 0.7324004,
        size.width * 0.06242188,
        size.height * 0.8537598,
        size.width * 0.06242188,
        size.height * 0.8537598);
    path_0.lineTo(size.width * 0.06262891, size.height * 0.02960156);
    path_0.cubicTo(
        size.width * 0.06262891,
        size.height * 0.01342188,
        size.width * 0.07574609,
        size.height * 0.0003046875,
        size.width * 0.09192578,
        size.height * 1.040834e-17);
    path_0.lineTo(size.width * 0.8810078, size.height * 1.040834e-17);
    path_0.cubicTo(
        size.width * 0.8971875,
        size.height * 0.0003046875,
        size.width * 0.9103047,
        size.height * 0.01342188,
        size.width * 0.9103047,
        size.height * 0.02960156);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.color = Color(0xffbee75e).withOpacity(1.0);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.8810059, 0);
    path_1.lineTo(size.width * 0.4990234, 0);
    path_1.lineTo(size.width * 0.4990234, size.height * 0.7324004);
    path_1.lineTo(size.width * 0.9103027, size.height * 0.7324004);
    path_1.lineTo(size.width * 0.9103027, size.height * 0.02960156);
    path_1.cubicTo(
        size.width * 0.9103027,
        size.height * 0.01342187,
        size.width * 0.8971855,
        size.height * 0.0003046875,
        size.width * 0.8810059,
        size.height * -1.006140e-16);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.color = Color(0xff00cb75).withOpacity(1.0);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.2235840, size.height * 0.9853828);
    path_2.lineTo(size.width * 0.8672656, size.height * 0.9853828);
    path_2.lineTo(size.width * 0.8672656, size.height * 0.7216523);
    path_2.lineTo(size.width * 0.2235840, size.height * 0.7216523);
    path_2.cubicTo(
        size.width * 0.1507578,
        size.height * 0.7216523,
        size.width * 0.09171875,
        size.height * 0.7806895,
        size.width * 0.09171875,
        size.height * 0.8535176);
    path_2.cubicTo(
        size.width * 0.09171875,
        size.height * 0.9263437,
        size.width * 0.1507559,
        size.height * 0.9853828,
        size.width * 0.2235840,
        size.height * 0.9853828);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.color = Color(0xfff9f2f2).withOpacity(1.0);
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.4990234, size.height * 0.7216523);
    path_3.lineTo(size.width * 0.8672656, size.height * 0.7216523);
    path_3.lineTo(size.width * 0.8672656, size.height * 0.9853809);
    path_3.lineTo(size.width * 0.4990234, size.height * 0.9853809);
    path_3.close();

    Paint paint_3_fill = Paint()..style = PaintingStyle.fill;
    paint_3_fill.color = Color(0xffe7e2ee).withOpacity(1.0);
    canvas.drawPath(path_3, paint_3_fill);

    Path path_4 = Path();
    path_4.moveTo(size.width * 0.8672656, size.height * 0.8242207);
    path_4.lineTo(size.width * 0.2074590, size.height * 0.8242207);
    path_4.cubicTo(
        size.width * 0.1912793,
        size.height * 0.8242207,
        size.width * 0.1781621,
        size.height * 0.8373379,
        size.width * 0.1781621,
        size.height * 0.8535176);
    path_4.cubicTo(
        size.width * 0.1781621,
        size.height * 0.8696973,
        size.width * 0.1912793,
        size.height * 0.8828145,
        size.width * 0.2074590,
        size.height * 0.8828145);
    path_4.lineTo(size.width * 0.8672656, size.height * 0.8828145);
    path_4.close();

    Paint paint_4_fill = Paint()..style = PaintingStyle.fill;
    paint_4_fill.color = Color(0xffe7e2ee).withOpacity(1.0);
    canvas.drawPath(path_4, paint_4_fill);

    Path path_5 = Path();
    path_5.moveTo(size.width * 0.4990234, size.height * 0.8242207);
    path_5.lineTo(size.width * 0.8672656, size.height * 0.8242207);
    path_5.lineTo(size.width * 0.8672656, size.height * 0.8828145);
    path_5.lineTo(size.width * 0.4990234, size.height * 0.8828145);
    path_5.close();

    Paint paint_5_fill = Paint()..style = PaintingStyle.fill;
    paint_5_fill.color = Color(0xffd5d3ea).withOpacity(1.0);
    canvas.drawPath(path_5, paint_5_fill);

    Path path_6 = Path();
    path_6.moveTo(size.width * 0.9082813, size.height);
    path_6.lineTo(size.width * 0.2089043, size.height);
    path_6.cubicTo(
        size.width * 0.1281328,
        size.height,
        size.width * 0.06242188,
        size.height * 0.9342871,
        size.width * 0.06242188,
        size.height * 0.8535176);
    path_6.cubicTo(
        size.width * 0.06242188,
        size.height * 0.7727480,
        size.width * 0.1281328,
        size.height * 0.7070352,
        size.width * 0.2089043,
        size.height * 0.7070352);
    path_6.lineTo(size.width * 0.9082813, size.height * 0.7070352);
    path_6.cubicTo(
        size.width * 0.9244609,
        size.height * 0.7070352,
        size.width * 0.9375781,
        size.height * 0.7201523,
        size.width * 0.9375781,
        size.height * 0.7363320);
    path_6.cubicTo(
        size.width * 0.9375781,
        size.height * 0.7525117,
        size.width * 0.9244609,
        size.height * 0.7656289,
        size.width * 0.9082813,
        size.height * 0.7656289);
    path_6.lineTo(size.width * 0.2089043, size.height * 0.7656289);
    path_6.cubicTo(
        size.width * 0.1604414,
        size.height * 0.7656289,
        size.width * 0.1210156,
        size.height * 0.8050547,
        size.width * 0.1210156,
        size.height * 0.8535176);
    path_6.cubicTo(
        size.width * 0.1210156,
        size.height * 0.9019805,
        size.width * 0.1604414,
        size.height * 0.9414063,
        size.width * 0.2089043,
        size.height * 0.9414063);
    path_6.lineTo(size.width * 0.9082813, size.height * 0.9414063);
    path_6.cubicTo(
        size.width * 0.9244609,
        size.height * 0.9414063,
        size.width * 0.9375781,
        size.height * 0.9545234,
        size.width * 0.9375781,
        size.height * 0.9707031);
    path_6.cubicTo(
        size.width * 0.9375781,
        size.height * 0.9868828,
        size.width * 0.9244609,
        size.height,
        size.width * 0.9082813,
        size.height);
    path_6.close();

    Paint paint_6_fill = Paint()..style = PaintingStyle.fill;
    paint_6_fill.color = Color(0xff00cb75).withOpacity(1.0);
    canvas.drawPath(path_6, paint_6_fill);

    Path path_7 = Path();
    path_7.moveTo(size.width * 0.9082813, size.height * 0.9414063);
    path_7.lineTo(size.width * 0.4990234, size.height * 0.9414063);
    path_7.lineTo(size.width * 0.4990234, size.height);
    path_7.lineTo(size.width * 0.9082813, size.height);
    path_7.cubicTo(
        size.width * 0.9244609,
        size.height,
        size.width * 0.9375781,
        size.height * 0.9868828,
        size.width * 0.9375781,
        size.height * 0.9707031);
    path_7.cubicTo(
        size.width * 0.9375781,
        size.height * 0.9545234,
        size.width * 0.9244609,
        size.height * 0.9414063,
        size.width * 0.9082813,
        size.height * 0.9414063);
    path_7.close();

    Paint paint_7_fill = Paint()..style = PaintingStyle.fill;
    paint_7_fill.color = Color(0xff009398).withOpacity(1.0);
    canvas.drawPath(path_7, paint_7_fill);

    Path path_8 = Path();
    path_8.moveTo(size.width * 0.4990234, size.height * 0.7656289);
    path_8.lineTo(size.width * 0.9082812, size.height * 0.7656289);
    path_8.cubicTo(
        size.width * 0.9244609,
        size.height * 0.7656289,
        size.width * 0.9375781,
        size.height * 0.7525117,
        size.width * 0.9375781,
        size.height * 0.7363320);
    path_8.cubicTo(
        size.width * 0.9375781,
        size.height * 0.7201523,
        size.width * 0.9244609,
        size.height * 0.7070352,
        size.width * 0.9082812,
        size.height * 0.7070352);
    path_8.lineTo(size.width * 0.4990234, size.height * 0.7070352);
    path_8.close();

    Paint paint_8_fill = Paint()..style = PaintingStyle.fill;
    paint_8_fill.color = Color(0xff009398).withOpacity(1.0);
    canvas.drawPath(path_8, paint_8_fill);

    Path path_9 = Path();
    path_9.moveTo(size.width * 0.7036289, size.height * 0.5486934);
    path_9.cubicTo(
        size.width * 0.5732695,
        size.height * 0.6051914,
        size.width * 0.4247793,
        size.height * 0.6051914,
        size.width * 0.2944199,
        size.height * 0.5486934);
    path_9.cubicTo(
        size.width * 0.2827949,
        size.height * 0.5436543,
        size.width * 0.2752773,
        size.height * 0.5321738,
        size.width * 0.2752773,
        size.height * 0.5195039);
    path_9.lineTo(size.width * 0.2752773, size.height * 0.2854531);
    path_9.lineTo(size.width * 0.7227695, size.height * 0.2854531);
    path_9.lineTo(size.width * 0.7227695, size.height * 0.5195059);
    path_9.cubicTo(
        size.width * 0.7227695,
        size.height * 0.5321758,
        size.width * 0.7152539,
        size.height * 0.5436562,
        size.width * 0.7036289,
        size.height * 0.5486934);
    path_9.close();

    Paint paint_9_fill = Paint()..style = PaintingStyle.fill;
    paint_9_fill.color = Color(0xff5e54ac).withOpacity(1.0);
    canvas.drawPath(path_9, paint_9_fill);

    Path path_10 = Path();
    path_10.moveTo(size.width * 0.4990234, size.height * 0.2854531);
    path_10.lineTo(size.width * 0.4990234, size.height * 0.5910684);
    path_10.cubicTo(
        size.width * 0.5687363,
        size.height * 0.5910684,
        size.width * 0.6384492,
        size.height * 0.5769434,
        size.width * 0.7036270,
        size.height * 0.5486953);
    path_10.cubicTo(
        size.width * 0.7152520,
        size.height * 0.5436562,
        size.width * 0.7227695,
        size.height * 0.5321758,
        size.width * 0.7227695,
        size.height * 0.5195059);
    path_10.lineTo(size.width * 0.7227695, size.height * 0.2854531);
    path_10.close();

    Paint paint_10_fill = Paint()..style = PaintingStyle.fill;
    paint_10_fill.color = Color(0xff38336b).withOpacity(1.0);
    canvas.drawPath(path_10, paint_10_fill);

    Path path_11 = Path();
    path_11.moveTo(size.width * 0.7998418, size.height * 0.2397773);
    path_11.cubicTo(
        size.width * 0.7822363,
        size.height * 0.2397773,
        size.width * 0.7679648,
        size.height * 0.2540488,
        size.width * 0.7679648,
        size.height * 0.2716543);
    path_11.lineTo(size.width * 0.7679648, size.height * 0.3737168);
    path_11.cubicTo(
        size.width * 0.7679648,
        size.height * 0.3913223,
        size.width * 0.7822363,
        size.height * 0.4055938,
        size.width * 0.7998418,
        size.height * 0.4055938);
    path_11.cubicTo(
        size.width * 0.8174473,
        size.height * 0.4055938,
        size.width * 0.8317188,
        size.height * 0.3913223,
        size.width * 0.8317188,
        size.height * 0.3737168);
    path_11.lineTo(size.width * 0.8317188, size.height * 0.2716543);
    path_11.cubicTo(
        size.width * 0.8317188,
        size.height * 0.2540488,
        size.width * 0.8174473,
        size.height * 0.2397773,
        size.width * 0.7998418,
        size.height * 0.2397773);
    path_11.close();

    Paint paint_11_fill = Paint()..style = PaintingStyle.fill;
    paint_11_fill.color = Color(0xff38336b).withOpacity(1.0);
    canvas.drawPath(path_11, paint_11_fill);

    Path path_12 = Path();
    path_12.moveTo(size.width * 0.4855078, size.height * 0.1257852);
    path_12.lineTo(size.width * 0.1885977, size.height * 0.2380234);
    path_12.cubicTo(
        size.width * 0.1556543,
        size.height * 0.2504766,
        size.width * 0.1556543,
        size.height * 0.2970781,
        size.width * 0.1885977,
        size.height * 0.3095332);
    path_12.lineTo(size.width * 0.4855059, size.height * 0.4217715);
    path_12.cubicTo(
        size.width * 0.4942168,
        size.height * 0.4250645,
        size.width * 0.5038281,
        size.height * 0.4250645,
        size.width * 0.5125391,
        size.height * 0.4217715);
    path_12.lineTo(size.width * 0.8094473, size.height * 0.3095332);
    path_12.cubicTo(
        size.width * 0.8423906,
        size.height * 0.2970801,
        size.width * 0.8423906,
        size.height * 0.2504785,
        size.width * 0.8094473,
        size.height * 0.2380234);
    path_12.lineTo(size.width * 0.5125391, size.height * 0.1257852);
    path_12.cubicTo(
        size.width * 0.5038301,
        size.height * 0.1224922,
        size.width * 0.4942168,
        size.height * 0.1224922,
        size.width * 0.4855078,
        size.height * 0.1257852);
    path_12.close();

    Paint paint_12_fill = Paint()..style = PaintingStyle.fill;
    paint_12_fill.color = Color(0xff8078be).withOpacity(1.0);
    canvas.drawPath(path_12, paint_12_fill);

    Path path_13 = Path();
    path_13.moveTo(size.width * 0.8094473, size.height * 0.2380234);
    path_13.lineTo(size.width * 0.5125391, size.height * 0.1257852);
    path_13.cubicTo(
        size.width * 0.5081836,
        size.height * 0.1241387,
        size.width * 0.5036035,
        size.height * 0.1233164,
        size.width * 0.4990234,
        size.height * 0.1233164);
    path_13.lineTo(size.width * 0.4990234, size.height * 0.4242422);
    path_13.cubicTo(
        size.width * 0.5036035,
        size.height * 0.4242422,
        size.width * 0.5081855,
        size.height * 0.4234199,
        size.width * 0.5125391,
        size.height * 0.4217734);
    path_13.lineTo(size.width * 0.8094473, size.height * 0.3095352);
    path_13.cubicTo(
        size.width * 0.8423926,
        size.height * 0.2970801,
        size.width * 0.8423926,
        size.height * 0.2504785,
        size.width * 0.8094473,
        size.height * 0.2380234);
    path_13.close();

    Paint paint_13_fill = Paint()..style = PaintingStyle.fill;
    paint_13_fill.color = Color(0xff5e54ac).withOpacity(1.0);
    canvas.drawPath(path_13, paint_13_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
