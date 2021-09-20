import 'package:application/wanderlist/cubit/wanderlist_cubit.dart';
import 'package:application/wanderlist/cubit/wanderlist_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';

class EmptyActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WanderlistCubit, WanderlistState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "There's nothing here yet!",
              style: TextStyle(color: Colors.grey, fontSize: 18),
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Container(
              decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(15.0)),
              child: TextButton(
                onPressed: () {
                  if (state is Viewing) {
                    context.read<WanderlistCubit>().startEdit(state.wanderlist);
                  }
                },
                child: Text(
                  "Add Activities",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ]),
        );
      },
      listener: (context, state) {},
    );
  }
}
