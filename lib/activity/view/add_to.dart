import 'package:application/activity/cubit/add_to_cubit.dart';
import 'package:application/activity/cubit/add_to_state.dart';
import 'package:application/components/list_of_wanderlists.dart';
import 'package:application/models/user_wanderlist.dart';
import 'package:application/repositories/activity/rest_activity_repository.dart';
import 'package:application/repositories/user/rest_user_repository.dart';
import 'package:application/repositories/wanderlist/rest_wanderlist_repository.dart';
import 'package:application/userwanderlists/widgets/new_wanderlist_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../apptheme.dart';

class _PageBody extends StatelessWidget {

  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocBuilder<ActivityAddCubit, ActivityAddState>(
      builder: (context, state) {
        if (state is ActivityAddLoaded) {
          var cubit = context.read<ActivityAddCubit>();
          return Scaffold(
                appBar: AppBar(
                  title: Text("Add to Wanderlist",
                    style: TextStyle(color: WanTheme.colors.pink),
                  ),
                ),
                floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Name your wanderlist",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.black,
                                  fontFamily: "Inter",
                                ),
                              ),
                              TextField(
                                controller: _nameController,
                              ),
                              AddWLModalButtons(() {
                                cubit.createWanderlist(_nameController.text);
                                var name = _nameController.text;
                                final snackBar = SnackBar(
                                  content: Text(
                                    'Added to new Wanderlist $name!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  backgroundColor: WanTheme.colors.pink,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);



                                Navigator.pop(context);
                              }
                              ),
                            ],
                          ),
                        ),
                      ));
                },
                  foregroundColor: Colors.white,
                  backgroundColor: WanTheme.colors.pink,
                label: Text("New Wanderlist"),
                icon: Icon(Icons.add_rounded),),
              body: Column (
                  children: [
                    Expanded (child: ListOfWanderlists(
                      wanderlists: state.wanderlists,
                      readOnly: true,
                      onWanderlistTap: (UserWanderlist wanderlist) {
                              cubit.addActivityToWanderlist(wanderlist.wanderlist);
                          Navigator.pop(context);
                        },
                      )),
                    ])
          );
        } else {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

/**
 * Page that appears when user clicks the "add to wanderlist" button on an
 * activity page
 */
class AddActivityPage extends StatelessWidget {
  const AddActivityPage(this.activityId, {Key? key}) : super(key: key);

  final String activityId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ActivityAddCubit(RestUserRepository(),
          RestWanderlistRepository(), RestActivityRepository(), activityId),
      child: _PageBody(),
    );
  }
}
