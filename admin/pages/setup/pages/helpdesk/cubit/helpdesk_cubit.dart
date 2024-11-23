import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'helpdesk_state.dart';

class HelpdeskCubit extends Cubit<HelpdeskState> {
  HelpdeskCubit() : super(HelpdeskInitial());
}
