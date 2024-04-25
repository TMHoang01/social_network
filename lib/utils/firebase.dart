import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_network/sl.dart';

FirebaseAuth firebaseAuth = sl<FirebaseAuth>();
FirebaseFirestore firestore = sl<FirebaseFirestore>();
FirebaseStorage storage = sl<FirebaseStorage>();

// Collection refs
CollectionReference usersRef = firestore.collection('users');
CollectionReference categoryRef = firestore.collection("categories");
CollectionReference productRef = firestore.collection('products');
CollectionReference cartRef = firestore.collection('carts');
CollectionReference orderRef = firestore.collection('orders');
CollectionReference inforContactRef = firestore.collection('inforContacts');
CollectionReference serviceRef = firestore.collection('services');
