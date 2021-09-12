import 'package:application/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'i_user_repository.dart';

class UserRepository implements IUserRepository {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Future<UserDetails> getThisUserData() async {
    final User user = auth.currentUser!;
    final uid = user.uid;

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot snapshot = await users.doc(uid).get();

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return UserDetails(data["email"], data['first_name'], data["last_name"]);
  }

}