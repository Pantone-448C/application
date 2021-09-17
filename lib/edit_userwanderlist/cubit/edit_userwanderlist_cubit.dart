import 'package:application/edit_userwanderlist/cubit/edit_userwanderlist_state.dart';
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit(this.wanderlistRepository) : super(Editing());

  IWanderlistRepository wanderlistRepository;

  Future<void> save() async {
    // TODO: Do stuff
  }

  Future<Wanderlist> retrieve(String docReference) async {
    return wanderlistRepository.getWanderlist(docReference);
  }
}