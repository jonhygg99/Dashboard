import 'package:firebase_db_web_unofficial/firebasedbwebunofficial.dart';
import 'package:firebase_db_web_unofficial/DatabaseSnapshot.dart';

class FirebaseDB {
  FirebaseDB();

  final DatabaseRef firebaseDatabaseWebReference = FirebaseDatabaseWeb.instance.reference();
  // final databaseReference = database.instance.reference();

  void createData(path, values) {
    FirebaseDatabaseWeb.instance
        .reference()
        .child("test")
        .child("a")
        .set("Click a button to change this to 'hello'");

    // FirebaseDatabaseWeb.instance.reference().child(path).set(values);
  }

  void updateData(path, title, value) {
    firebaseDatabaseWebReference.child(path).update({title: value});
  }

  Future<void> readData(path) async {
    DatabaseSnapshot snap =
        await firebaseDatabaseWebReference.child(path).once();
    print(snap.value);
  }

  void deleteData(path) => firebaseDatabaseWebReference.child(path).remove();
}
