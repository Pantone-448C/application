/**
 * Page that appears when user clicks the "add to wanderlist" button on an
 * activity page
 */
class _AddActivityPage extends StatelessWidget {
  const _AddActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
    //return BlocBuilder<ActivityCubit, ActivityState>(builder: (context, state) {
    //  return ListOfWanderlists(
    //    readOnly: true,
    //    onWanderlistTap: (UserWanderlist wanderlist) {
    //      context.read<ActivityCubit>().addActivityToWanderlist(wanderlist.id);
    //    },
    //  );
    //});
  }
}
