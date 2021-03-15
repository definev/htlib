import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';

class SliverIndicator extends StatelessWidget {
  final double? height;

  const SliverIndicator({Key? key, this.height}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CircularProgressIndicator()
          .constrained(height: 150, width: 150)
          .center()
          .constrained(height: MediaQuery.of(context).size.height - height!),
    );
  }
}
