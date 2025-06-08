import 'package:flutter_bloc/flutter_bloc.dart';

class ShellCubit extends Cubit<int> {
  ShellCubit() : super(0);        // 0 = Home, 1 = Profile
  void changeTab(int i) => emit(i);
}
