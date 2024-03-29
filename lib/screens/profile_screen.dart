import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/ressources/auth_methods.dart';
import 'package:instagram_clone/ressources/firestone_methods.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({ Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();

      // get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: userSnap.id)
          .get();
      postLen = postSnap.docs.length;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      userData = userSnap.data()!;
      setState(() {

      });
    }catch(e){
      showSnackBar(e.toString(), context);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: Builder(
                builder: (context) {
                  return IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => width < webScreenSize ? const MobileScreenLayout(): const WebScreenLayout()
                          )
                      )
                  );
                },
              ),
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
            ),
            body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            userData['photoUrl'],
                          ),
                          radius: 40,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildStatColum(postLen, 'posts'),
                                  buildStatColum(followers, 'followers'),
                                  buildStatColum(following, 'following'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  FirebaseAuth.instance.currentUser!.uid == widget.uid ?
                                  FollowButton(
                                    backgroundColor: mobileBackgroundColor,
                                    borderColor: Colors.grey,
                                    textColor: primaryColor,
                                    text: 'Sign out',
                                    function: () async {
                                      await AuthMethods().signOut(context);
                                    },
                                  ): isFollowing ?
                                  FollowButton(
                                    backgroundColor: Colors.white,
                                    borderColor: Colors.grey,
                                    textColor: Colors.black,
                                    text: 'Unfollow',
                                    function: () async {
                                      await FirestoreMethods().followUser(
                                       FirebaseAuth.instance.currentUser!.uid,
                                       userData['uid']
                                      );
                                      setState(() {
                                        isFollowing = false;
                                        followers--;
                                      });
                                    },
                                  ): FollowButton(
                                    backgroundColor: blueColor,
                                    borderColor: blueColor,
                                    textColor: primaryColor,
                                    text: 'Follow',
                                    function: () async {
                                      await FirestoreMethods().followUser(
                                          FirebaseAuth.instance.currentUser!.uid,
                                          userData['uid']
                                      );
                                      setState(() {
                                        isFollowing = true;
                                        followers++;
                                      });
                                    },
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        userData['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 1),
                      child: Text(
                        userData['bio'],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];
                      return Image(
                        image: NetworkImage(
                            snap['postUrl'],
                        ),
                        fit: BoxFit.cover,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      }

      Column buildStatColum(int num, String label) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              num.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 4,),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey,
                ),
              ),
            )
          ],
    );
  }
}