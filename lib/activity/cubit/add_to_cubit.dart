import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_to_state.dart';

class ActivityAddCubit extends Cubit<ActivityAddState> {
  ActivityAddCubit(
    this.wanderlistRepository,
    this.id,
  ) : super(ActivityAddInitial()) {
    emit(ActivityAddInitial());
  }

  final IWanderlistRepository wanderlistRepository;
  final String id;
}
