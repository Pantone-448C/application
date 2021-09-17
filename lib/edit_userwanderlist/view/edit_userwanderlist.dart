import 'package:application/apptheme.dart';
import 'package:application/edit_userwanderlist/cubit/edit_userwanderlist_cubit.dart';
import 'package:application/edit_userwanderlist/widgets/activity_list.dart';
import 'package:application/repositories/wanderlist/wanderlist_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditUserWanderlistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditCubit>(
        create: (context) => EditCubit(WanderlistRepository()),
        child: _EditContainer());
  }
}

class _EditContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(),
            _Dots(),
            //ActivityList(),
            _ModalButtons(),
          ],
        );
      },
      listener: (BuildContext context, Object? state) {},
    );
  }
}

class _Dots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class _ModalButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      builder: (context, state) {
        return buttonRow(context, context.read<EditCubit>());
      },
      listener: (BuildContext context, Object? state) {},
    );
  }

  Widget buttonRow(BuildContext context, EditCubit cubit) {
    return Row(
      children: [
        Spacer(flex: 3),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => cubit.save(),
              style: ElevatedButton.styleFrom(primary: WanTheme.colors.grey),
              child: Text("Cancel"),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(primary: WanTheme.colors.pink),
              child: Text("Save"),
            ),
          ),
        ),
        Spacer(flex: 3),
      ],
    );
  }
}
