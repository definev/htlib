part of 'diagram_node_config_cubit.dart';

@freezed
abstract class DiagramNodeConfigState with _$DiagramNodeConfigState {
  const factory DiagramNodeConfigState.initial() = _Initial;
  const factory DiagramNodeConfigState.done(DiagramNode node) = _Done;
}
