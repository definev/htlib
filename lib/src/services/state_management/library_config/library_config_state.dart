part of 'library_config_cubit.dart';

@freezed
abstract class LibraryConfigState with _$LibraryConfigState {
  const factory LibraryConfigState.initial() = _Initial;
  const factory LibraryConfigState.done(LibraryConfig config) = _Done;
}
