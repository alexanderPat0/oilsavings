import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:oilsavings/models/UserModel.dart';

class UserServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  Future<void> signUp(
      String email, String password, String name, String mainFuel) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;

      UserData user = UserData(
        id: uid,
        email: email,
        username: name,
        mainFuel: mainFuel,
      );

      await _dbRef.child('users').child(uid).set(user.toJson());
    } catch (e) {
      throw Exception('Error registering user: $e');
    }
  }

  Future<String> getMainFuel() async {
    try {
      User? user = _auth.currentUser;
      String userId = user!.uid;
      final snapshot = await _dbRef.child('users/$userId/mainFuel').get();
      if (snapshot.exists) {
        return snapshot.value.toString();
      } else {
        throw Exception('MainFuel not found for user: $userId');
      }
    } catch (e) {
      throw Exception('Error getting user mainFuel: $e');
    }
  }

  Future<void> changeMainFuel(String mainFuel) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String uid = user.uid;
        await _dbRef.child('users').child(uid).update({'mainFuel': mainFuel});
      } else {
        throw Exception('No user currently signed in.');
      }
    } catch (e) {
      throw Exception('Error updating mainFuel: $e');
    }
  }
}
  // Future<void> writeNewPost(
  //     String uid, String gasStationId, String body) async {
  //   final postData = {
  //     'userId': uid,
  //     'gasStationId': gasStationId,
  //     'body': body,
  //   };

  //   // Get a key for a new post
  //   final newPostKey = _database.ref().child('posts').push().key;

  //   if (newPostKey != null) {
  //     // Write the new post's data simultaneously in the posts list and the user's post list
  //     final Map<String, Map> updates = {};
  //     updates['/posts/$newPostKey'] = postData;
  //     updates['/user-posts/$uid/$newPostKey'] = postData;

  //     await _database.ref().update(updates);
  //   }
  // }