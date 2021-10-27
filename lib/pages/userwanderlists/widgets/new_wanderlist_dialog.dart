import 'package:application/pages/userwanderlists/cubit/userwanderlists_cubit.dart';
import 'package:application/pages/userwanderlists/cubit/userwanderlists_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewWanderlistDialog extends StatelessWidget {
  NewWanderlistDialog(this.parentCubit);

  final parentCubit; // UserWanderlistsCubit
  final _nameController = TextEditingController();

  _createButtonCallback() {
    parentCubit.addEmptyUserWanderlist(_nameController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
            AddWLModalButtons(_createButtonCallback),
          ],
        ),
      ),
    );
  }
}

class AddWLModalButtons extends StatelessWidget {
  AddWLModalButtons(this.createButtonCallback);

  final Function() createButtonCallback;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 5)),
        Container(
          child: TextButton(
            onPressed: () {
              createButtonCallback();
              Navigator.of(context).pop();
            },
            child: Text("Create"),
          ),
        ),
      ],
    );
  }
}
