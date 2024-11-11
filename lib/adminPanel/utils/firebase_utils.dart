import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:iw_admin_panel/adminPanel/utils/snackmessage.dart';


import 'mediaquery.dart';

class FirebaseUtils{


  static final auth=FirebaseAuth.instance;
  static String currentUser=auth.currentUser!.uid;
  /// for creating collections of users
  static final users=FirebaseFirestore.instance.collection("users");
  static final shifts=FirebaseFirestore.instance.collection("shifts");
  static final nurseUsers=FirebaseFirestore.instance.collection("nurse_users");
  static final practiceUsers=FirebaseFirestore.instance.collection("practice_users");
  static final jobPost=FirebaseFirestore.instance.collection("job_post");
  static final appliedJobCollection=FirebaseFirestore.instance.collection("applied_job");
  static final nurseScrub=FirebaseFirestore.instance.collection("nurse_scrub");
  static final conversation=FirebaseFirestore.instance.collection("conversations");
  static final userContactToAdmin=FirebaseFirestore.instance.collection("userContactToAdmin");
  static final adminChatCollection=FirebaseFirestore.instance.collection("adminChatCollection");
  static CollectionReference appliedJobCollectionReference=appliedJobCollection;

  static DocumentReference documentReference=appliedJobCollection.doc();
  static final defaultJobDesCollection=FirebaseFirestore.instance.collection("default_job_descriptions");

  static final nurseAvailableCollection=FirebaseFirestore.instance.collection("nurse_available");

  static final jobsDetail=FirebaseFirestore.instance.collection("jobs_detail");
  static final appliedBooking=FirebaseFirestore.instance.collection("applied_booking");
  static final notifications=FirebaseFirestore.instance.collection("notifications");
  static const subCollection='my_notifications';
  static final workingHours=FirebaseFirestore.instance.collection("working_hours");
  static final appliedJobTracking=FirebaseFirestore.instance.collection("applied_job_tracking");


  ///for getting records of users using future
  static void gerRecordOfUsers()async{
    await users.get();
  }
  static void gerRecordOfNurses()async{
    await nurseUsers.get();
  }
  static Future<Map<String, dynamic>> getRecordOfUser() async {
    var document = await users.doc(FirebaseAuth.instance.currentUser!.uid).get();

    /// Check if the document exists and contains data
    if (document.exists) {
      /// Convert the data to a Map and return
      return document.data() as Map<String, dynamic>;
    } else {
      /// Handle the case where the document doesn't exist
      return {}; // or throw an exception, depending on your use case
    }
  }
  static void gerRecordOfJobPost()async{
    await jobPost.get();
  }

  ///for getting records of users using Streams
  static Stream<QuerySnapshot> getUsersStream(){
    return users.snapshots();
  }

  static Stream<QuerySnapshot> getNursesStream(){
    return nurseUsers.snapshots();
  }

  static Stream<QuerySnapshot> getPracticesStream(){
    return practiceUsers.snapshots();
  }
  static Stream<QuerySnapshot> getPracticesJobPostStream(){
    return jobPost.snapshots();
  }


  /// for getting document snapshot
  static getDocument(String collectionName, String docId)async{

    DocumentSnapshot documentSnapshot=await FirebaseFirestore.instance.collection(collectionName).doc(docId).get();
    return documentSnapshot;
  }
  /// for get document with future

  static Future<DocumentSnapshot<Map<String, dynamic>>> getDocumentById(
      String collection, String docId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance.collection(collection).doc(docId).get();

      if (snapshot.exists) {
        return snapshot;
      } else {
        throw Exception('Document not found');
      }
    } catch (e) {
      // Handle errors, e.g., network issues, permissions, etc.
      Utils.toastMessage(e.toString(), redColor);
      rethrow; // Re-throw the exception to allow the caller to handle it
    }
  }

  static Future<void> updatePracticeNameInJobPost(String userId, String newName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the collection
    CollectionReference collectionRef = firestore.collection('job_post');

    // Check if the collection exists by trying to get its documents
    var collectionSnapshot = await collectionRef.limit(1).get();

    if (collectionSnapshot.size == 0) {
      return;
    }

    // Query to find documents where userId matches
    var querySnapshot = await collectionRef
        .where('job_poster_id', isEqualTo: userId)
        .get();

    // Check if documents exist with the provided userId
    if (querySnapshot.docs.isEmpty) {
      return;
    }

    // Perform the update on each document
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'practiceName': newName});
    }
  }
  static Future<void> updateNurseNameInJobDetail(String userId, String newName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the collection
    CollectionReference collectionRef = firestore.collection('jobs_detail');

    // Check if the collection exists by trying to get its documents
    var collectionSnapshot = await collectionRef.limit(1).get();

    if (collectionSnapshot.size == 0) {
      return;
    }

    // Query to find documents where userId matches
    var querySnapshot = await collectionRef
        .where('nurseId', isEqualTo: userId)
        .get();

    // Check if documents exist with the provided userId
    if (querySnapshot.docs.isEmpty) {
      return;
    }

    // Perform the update on each document
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'nurseName': newName});
    }
  }
  static Future<void> updatePracticeNameInJobsDetail(String userId, String newName) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the collection
    CollectionReference collectionRef = firestore.collection('jobs_detail');

    // Check if the collection exists by trying to get its documents
    var collectionSnapshot = await collectionRef.limit(1).get();

    if (collectionSnapshot.size == 0) {
      return;
    }

    // Query to find documents where userId matches
    var querySnapshot = await collectionRef
        .where('practiceId', isEqualTo: userId)
        .get();

    // Check if documents exist with the provided userId
    if (querySnapshot.docs.isEmpty) {
      return;
    }

    // Perform the update on each document
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'practiceName': newName});
    }
  }
  static Future<void> updatePracticeProfilePicInJobDetail(String userId, String newStatus) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the collection
    CollectionReference collectionRef = firestore.collection('jobs_detail');

    // Check if the collection exists by trying to get its documents
    var collectionSnapshot = await collectionRef.limit(1).get();

    if (collectionSnapshot.size == 0) {
      return;
    }

    // Query to find documents where userId matches
    var querySnapshot = await collectionRef
        .where('practiceId', isEqualTo: userId)
        .get();

    // Check if documents exist with the provided userId
    if (querySnapshot.docs.isEmpty) {
      return;
    }

    // Perform the update on each document
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'practiceImg': newStatus});
    }
  }
  static Future<void> updatePracticeProfilePicJobPost(String userId, String newStatus) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Reference to the collection
    CollectionReference collectionRef = firestore.collection('job_post');

    // Check if the collection exists by trying to get its documents
    var collectionSnapshot = await collectionRef.limit(1).get();

    if (collectionSnapshot.size == 0) {
      return;
    }

    // Query to find documents where userId matches
    var querySnapshot = await collectionRef
        .where('job_poster_id', isEqualTo: userId)
        .get();

    // Check if documents exist with the provided userId
    if (querySnapshot.docs.isEmpty) {
      return;
    }

    // Perform the update on each document
    for (var doc in querySnapshot.docs) {
      await doc.reference.update({'practiceImg': newStatus});
    }
  }

  static Future<void> savedShifts(String jobDetailId,List<dynamic>bookingRecord)async{
    users.doc(FirebaseAuth.instance.currentUser!.uid).collection('shifts').doc(jobDetailId).set({
      'jobDetailId':jobDetailId,
      'completionDate':DateTime.now(),
      'bookingRecord':bookingRecord
    }).then((value){
      debugPrint("Shift saved");
    });
  }



}