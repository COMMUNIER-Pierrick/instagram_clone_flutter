import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

import '../models/userDataModel.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({ Key? key}) : super(key: key);

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {

  int _page = 0;
  late PageController pageController;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState(){
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose(){
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page){
    pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page){
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider
        .of<UserProvider>(context)
        .getUser;
    final width = MediaQuery.of(context).size.width;
    final ScrollController scrollBarController = ScrollController();

    return Scaffold(
        appBar: width < webScreenSize ? null: AppBar(
          shadowColor: Colors.grey,
          automaticallyImplyLeading: false,
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          actions: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            SvgPicture.asset(
              'assets/logo_instagram.svg',
              color: Colors.white,
              height: 32,
            ),
            //if(MediaQuery.of(context).size.width > webScreenSize)
            Flexible(
              child: Container(),
              flex: 1,
            ),
            Container(
              constraints: const BoxConstraints(
                  maxWidth: 250
              ),
              padding: const EdgeInsets.symmetric(vertical: 2),
              height: 50,
              child: FirestoreSearchBar(
                tag: 'search',
              ),
            ),
            Flexible(
              child: Container(),
              flex: 1,
            ),
            IconButton(
              onPressed: () => navigationTapped(0),
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColors,
              ),
            ),
            IconButton(
              onPressed: () => navigationTapped(1),
              icon: Icon(
                Icons.send,
                color: _page == 1 ? primaryColor : secondaryColors,
              ),
            ),
            IconButton(
              onPressed: () => navigationTapped(2),
              icon: Icon(
                Icons.add_box_outlined,
                color: _page == 2 ? primaryColor : secondaryColors,
              ),
            ),
            IconButton(
              onPressed: () => navigationTapped(3),
              icon: Icon(
                Icons.explore_outlined,
                color: _page == 3 ? primaryColor : secondaryColors,
              ),
            ),
            IconButton(
              onPressed: () => navigationTapped(4),
              icon: Icon(
                Icons.favorite,
                color: _page == 4 ? primaryColor : secondaryColors,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ).copyWith(right: 0),
              child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: (user.uid),)),
                      ),
                      child: CircleAvatar(
                        radius: 10,
                        backgroundImage: NetworkImage(
                          user.photoUrl,
                        ),
                      ),
                    ),
                  ]),
            ),
            Flexible(
              child: Container(),
              flex: 2,
            ),
          ],
        ),
        body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('users')
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return FirestoreSearchResults.builder(
              resultsBodyBackgroundColor: webBackgroundColor,
              tag: 'search',
              firestoreCollectionName: 'users',
              searchBy: 'username',
              initialBody: PageView(
                physics: const NeverScrollableScrollPhysics(),
                children: homeScreenItems,
                controller: pageController,
                onPageChanged: onPageChanged,
              ),
              dataListFromSnapshot: const UserDataModel().dataListFromSnapshot,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final List<UserDataModel>? usersList = snapshot.data;
                  if (usersList!.isEmpty) {
                    return const Center(
                      child: Text('No Results Returned'),
                    );
                  }
                  return Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: webBackgroundColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: secondaryColors,
                              spreadRadius: 0.5,
                              blurRadius: 7,
                              offset: Offset(0, 3)
                          )
                        ]
                    ),
                    margin: EdgeInsets.symmetric(horizontal: width*0.35),
                    height: 250,
                    child: Scrollbar(
                      controller: scrollBarController,
                      thumbVisibility: true,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 5),
                          controller: scrollBarController,
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
                          }),
                    ),
                  );
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
              },
            );
          },
        )
    );
  }
}