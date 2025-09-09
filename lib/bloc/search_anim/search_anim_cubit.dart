import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'search_anim_state.dart';

class SearchAnimCubit extends Cubit<SearchAnimState> {
  SearchAnimCubit() : super(SearchAnimClose());

  void makeItClose() {
    emit(SearchAnimClose());
  }

  void makeItOpen() {
    emit(SearchAnimOpen());
  }
}
