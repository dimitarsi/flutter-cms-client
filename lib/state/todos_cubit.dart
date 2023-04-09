import 'package:flutter_bloc/flutter_bloc.dart';

class TodosCubit extends Cubit<List<String>> {
  TodosCubit(super.initialState);

  void addItem(String item) {
    emit([...state, item]);
  }

  void removeItem(String item) {
    state.remove(item);
    emit([...state]);
  }
}
