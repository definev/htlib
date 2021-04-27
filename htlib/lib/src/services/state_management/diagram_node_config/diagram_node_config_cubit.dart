import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:htlib/src/model/diagram_node.dart';
import 'package:htlib/src/model/diagram_node_mode.dart';

part 'diagram_node_config_state.dart';
part 'diagram_node_config_cubit.freezed.dart';

class DiagramNodeConfigCubit extends Cubit<DiagramNodeConfigState> {
  DiagramNode _node;
  DiagramNodeConfigCubit(this._node)
      : super(DiagramNodeConfigState.done(_node));

  void changeLabel(String label) {
    _node = _node.copyWith(label: label);
    emit(DiagramNodeConfigState.done(_node));
  }

  void changeMode(DiagramNodeMode mode) {
    _node = _node.copyWith(mode: mode);
    emit(DiagramNodeConfigState.done(_node));
  }
}
