import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/userDataModel.dart';
import 'package:instagram_clone/screens/profile_screen.dart';

import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({ Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return FirestoreSearchScaffold(
        firestoreCollectionName: 'users',
        searchBy: 'username',
        searchBackgroundColor: mobileBackgroundColor,
        appBarBackgroundColor: webBackgroundColor,
        searchBodyBackgroundColor: webBackgroundColor,
        clearSearchButtonColor: secondaryColors,
        scaffoldBody: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('posts')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                  child: CircularProgressIndicator()
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
        dataListFromSnapshot: UserDataModel().dataListFromSnapshot,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<UserDataModel>? usersList = snapshot.data;
            if (usersList!.isEmpty) {
              return const Center(
                child: Text('No Results Returned', style: TextStyle(color: Colors.white),),
              );
            }
            return ListView.builder(
                itemCount: usersList.length < 8 ? usersList.length: 8,
                itemBuilder: (context, index) {
                  final UserDataModel user = usersList[index];
                  return InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(
                            uid: user.uid!
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          user.photoUrl!,
                        ),
                      ),
                      title: Text(
                        user.username!,
                      ),
                    ),
                  );
                });
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (!snapshot.hasData) {
              return const Center(
                child: Text('No Results Returned'),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }
}



// return Scaffold(
//    appBar: AppBar(
//     automaticallyImplyLeading: width > webScreenSize ? false : true,
//     backgroundColor: mobileBackgroundColor,
//     centerTitle: false,
//     title: TextFormField(
//       decoration: const InputDecoration(
//         labelText: 'Search for user',
//       ),
//       onChanged: (String _) {
//         setState(() {
//           isShowUsers = true;
//         });
//       },
//     ),
//   ),
//   body:FutureBuilder(
//     future: FirebaseFirestore.instance
//         .collection('users')
//         .where('username', isGreaterThanOrEqualTo: searchController.text)
//         .get(),
//     builder: (context, snapshot) {
//       if(!snapshot.hasData) {
//         return const Center(
//           child: CircularProgressIndicator(),
//         );
//       }
//       return ListView.builder(
//         itemCount: (snapshot.data! as dynamic).docs.length,
//         itemBuilder: (context, index) {
//           return InkWell(
//             onTap: () => Navigator.of(context).push(
//               MaterialPageRoute(
//                   builder: (context) => ProfileScreen(
//                       uid: (snapshot.data! as dynamic).docs[index]['uid'])
//               ),
//             ),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundImage: NetworkImage(
//                   (snapshot.data! as dynamic).docs[index]['photoUrl'],
//                 ),
//               ),
//               title: Text(
//                 (snapshot.data! as dynamic).docs[index]['username'],
//               ),
//             ),
//           );
//         },
//       );
//     },
//   ),