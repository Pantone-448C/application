import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WanderlistRepository implements IWanderlistRepository {
  final CollectionReference _wanderlists =
      FirebaseFirestore.instance.collection('wanderlists');
  final CollectionReference _activities =
      FirebaseFirestore.instance.collection('activities');

  @override
  Future<Wanderlist> getWanderlist(String id) async {
    DocumentSnapshot snapshot = await _wanderlists.doc(id).get();
    var data = snapshot.data() as Map<String, dynamic>;
    data["doc_id"] = id;
    return Wanderlist.fromJson(data);
  }

  @override
  Future<void> setWanderlist(Wanderlist wanderlist) async {
    await _wanderlists.doc(wanderlist.id).set({
      'activities': wanderlist.activities.map((activity) {
        return _activities.doc(activity.id);
      }).toList(),
      'author_name': wanderlist.creatorName,
      'icon': wanderlist.icon,
      'name': wanderlist.name
    });
  }
}
