import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboard_state.dart';

class OnboardCubit extends Cubit<OnboardState> {
  OnboardCubit() : super(OnboardInitial());
}
