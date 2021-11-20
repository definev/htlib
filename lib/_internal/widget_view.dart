import 'package:flutter/material.dart';

abstract class WidgetView<T1 extends StatefulWidget, T2 extends State>
    extends StatelessWidget {
  final T2 state;

  T1 get widget => state.widget as T1;

  const WidgetView(this.state, {Key? key}) : super(key: key);
}

abstract class StatelessView<T1> extends StatelessWidget {
  final T1 widget;

  const StatelessView(this.widget, {Key? key}) : super(key: key);
}
