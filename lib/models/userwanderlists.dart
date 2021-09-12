


class UserWanderlistItem {
  UserWanderlistItem ({
      required this.id,
      required this.name,
      required this.creatorName,
      required this.image,
  });

  int id;
  String name;
  String creatorName;
  String image;
}

class UserWanderlist {
  UserWanderlist({
      required this.userId,
      required this.numCompleted,
      required this.numTotal,
      required this.wanderlist,
  });

  int userId;
  int numCompleted;
  int numTotal;
  UserWanderlistItem wanderlist;

  // Every prop intended to be used in a filtering or sorting operation
  // should be included in this operator overload.
  dynamic operator [](String prop) {
    switch (prop) {
      case 'name':
        return wanderlist.name;
        break;
      case 'creator':
        return wanderlist.creatorName;
        break;
      default:
        throw ArgumentError('Property `$prop` does not exist on JournalEntry.');
    }
  }

  @override
  List<Object> get props =>
      [wanderlist.name, wanderlist.creatorName];
}

class UserWanderlists {
  UserWanderlists (
      this.id,
      this.wanderlists,
      );

  int id;
  List<UserWanderlist> wanderlists;
}

