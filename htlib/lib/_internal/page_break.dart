import 'package:flutter/material.dart';

class PageBreak {
  static const PageBreak defaultPB = PageBreak(
    mobile: 650.0,
    tablet: 750.0,
    desktop: 1440.0,
  );

  final double mobile;
  final double tablet;
  final double desktop;

  const PageBreak({this.mobile, this.tablet, this.desktop});

  bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktop;

  bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= tablet && !isDesktop(context);

  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tablet;
}
