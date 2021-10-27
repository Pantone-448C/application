
import 'package:application/models/wanderlist.dart';
import 'package:application/repositories/rest_api.dart';
import 'package:application/repositories/wanderlist/i_wanderlist_repository.dart';

class RestWanderlistRepository implements IWanderlistRepository {
  @override
  Future<Wanderlist> getWanderlist(String id) async {
    var data = await getDocument(restUri("wanderlists/" + id, {}))
        as Map<String, dynamic>;
    return Wanderlist.fromJson(data);
  }

  @override
  Future<void> setWanderlist(Wanderlist wanderlist) async {
    return postDocument(
        restUri("wanderlists/" + wanderlist.id, {}), wanderlist.toJson());
  }

  @override
  Future<Wanderlist> addWanderlist(Wanderlist wanderlist) async {
    var res =
        await createDocument(restUri("wanderlists", {}), wanderlist.toJson())
            as Map<String, dynamic>;
    return Wanderlist.fromJson(res);
  }
}
