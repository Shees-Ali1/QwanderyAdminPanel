import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController extends GetxController {
  RxString user_id = "".obs;

  Future<void> sendMessage(String message, DateTime time,TextEditingController controller) async {
    try{
      await FirebaseFirestore.instance.collection("online_support").doc(user_id.value).collection("messages").add({
        "sent_at": time,
        "message": message,
        "user_uid": FirebaseAuth.instance.currentUser!.uid,
      }).then((val){
        controller.clear();
      });

      await FirebaseFirestore.instance.collection("online_support").doc(user_id.value).set({
        "seen": false,
        "last_message_sent_at": time,
        "uid": user_id.value,
        "replier_id": FirebaseAuth.instance.currentUser!.uid,
      }, SetOptions(merge: true));

    } catch (e){
      debugPrint("Error while sending message: $e");
    }
  }

  Stream<QuerySnapshot> getMessages() {

    print("this is value" + user_id.value);

    try {
      return FirebaseFirestore.instance
          .collection("online_support")
          .doc(user_id.value)
          .collection("messages")
          .orderBy("sent_at", descending: false)
          .snapshots();
    } catch (e) {
      debugPrint("Error fetching messages: $e");
      return const Stream.empty();
    }
  }

}