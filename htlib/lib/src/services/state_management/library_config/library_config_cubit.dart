import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:htlib/src/view/book_management/library_diagrams/model/library_config.dart';

part 'library_config_state.dart';
part 'library_config_cubit.freezed.dart';

class LibraryConfigCubit extends Cubit<LibraryConfigState> {
  LibraryConfig _config;

  LibraryConfigCubit(this._config) : super(LibraryConfigState.done(_config));

  editHeight(double height) {
    _config = LibraryConfig(height, _config.width, _config.size);
    emit(LibraryConfigState.done(_config));
  }

  editWidth(double width) {
    _config = LibraryConfig(_config.height, width, _config.size);
    emit(LibraryConfigState.done(_config));
  }

  editSize(double size) {
    _config = LibraryConfig(_config.height, _config.width, size);
    emit(LibraryConfigState.done(_config));
  }
}
