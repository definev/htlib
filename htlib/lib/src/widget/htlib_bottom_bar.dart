import 'dart:math';

import 'package:flutter/material.dart';
import 'package:htlib/styles.dart';
import 'package:provider/provider.dart';
import 'package:htlib/src/services/state_management/htlib_bottom_bar_notifier.dart';

class HtlibBottomBar extends StatefulWidget {
  const HtlibBottomBar({Key? key}) : super(key: key);

  @override
  _HtlibBottomBarState createState() => _HtlibBottomBarState();
}

class _HtlibBottomBarState extends State<HtlibBottomBar> {
  @override
  Widget build(BuildContext context) {
    HtlibBottomBarNotifier _notifier = context.read();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: _notifier.expand ? 300 : 56,
      width: double.infinity,
      color: Color.lerp(
          Theme.of(context).colorScheme.background,
          Theme.of(context).colorScheme.brightness == Brightness.dark
              ? Colors.white
              : Theme.of(context).primaryColor,
          0.05),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Insets.m, vertical: 21 / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Danh sách sách chưa phân loại",
                    style: Theme.of(context).textTheme.subtitle1),
                SizedBox(
                  height: 35,
                  width: 35,
                  child: ElevatedButton(
                    onPressed: () {
                      _notifier.setExpand(!_notifier.expand);
                      setState(() {});
                    },
                    child: TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 250),
                      builder: (context, value, child) =>
                          Transform.rotate(angle: -pi * value, child: child!),
                      tween: Tween<double>(
                          begin: 0, end: _notifier.expand ? 1 : 0),
                      child: Icon(Icons.expand_less_outlined, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Color.lerp(
                  Theme.of(context).colorScheme.background,
                  Theme.of(context).colorScheme.brightness == Brightness.dark
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  0.1),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => Draggable<String>(
                  data: "ID",
                  feedback: Container(
                    height: 50.0,
                    width: 200.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          color: Theme.of(context)
                              .colorScheme
                              .onBackground
                              .withOpacity(0.3),
                        )
                      ],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    margin: EdgeInsets.only(right: Insets.m),
                  ),
                  child: Container(
                    height: double.infinity,
                    width: 250.0,
                    color: Colors.white,
                    margin: EdgeInsets.only(right: Insets.m),
                  ),
                ),
                padding: EdgeInsets.only(
                  top: Insets.m,
                  bottom: Insets.m,
                  left: Insets.m,
                ),
                itemCount: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
