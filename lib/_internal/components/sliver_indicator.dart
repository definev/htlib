import 'package:flutter/material.dart';

class SliverIndicator extends StatelessWidget {
  final double? height;

  const SliverIndicator({Key? key, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: SizedBox(
      height: MediaQuery.of(context).size.height - height!,
      child: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: CircularProgressIndicator(),
        ),
      ),
    ));
  }
}
