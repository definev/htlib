import 'package:flutter/cupertino.dart';

class LayerStackElement extends StatelessWidget {
  final int layerIndex;
  final Widget child;

  const LayerStackElement({Key key, this.layerIndex, this.child})
      : assert(child != null && layerIndex != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class LayerStack extends StatelessWidget {
  final List<LayerStackElement> children;

  const LayerStack({Key key, this.children}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: children.qs());
  }
}

extension ArrExt on List<LayerStackElement> {
  List<LayerStackElement> qs() {
    this.sort((a, b) => b.layerIndex.compareTo(a.layerIndex));
    return this;
  }
}
