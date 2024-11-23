import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'basic_state.dart';

class BasicCubit extends Cubit<BasicState> {
  BasicCubit() : super(BasicInitial());
}
