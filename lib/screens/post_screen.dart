import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/search_screen.dart';

import '../utils/colors.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({ Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          title: TextFormField(
            decoration: const InputDecoration(
              labelText: 'Search for user',
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                //Ne fonctionne pas !!!!
                Navigator.of(context).push(
                    MaterialPageRoute(
                    builder: (context) => SearchScreen()));
              });
            },
          ),
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => Image.network(
                (snapshot.data! as dynamic).docs[index]['postUrl'],
                fit: BoxFit.cover,
              ),
            );
          },
        ),
    );
  }
}