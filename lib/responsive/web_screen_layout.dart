import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

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

    return Scaffold(
      appBar: width < webScreenSize ? null: AppBar(
        shadowColor: Colors.grey,
        elevation: 2,
        automaticallyImplyLeading: false,
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        actions: [
          Flexible(
            child: Container(),
            flex: 3,
          ),
          SvgPicture.asset(
            'assets/logo_instagram.svg',
            color: Colors.white,
            height: 32,
          ),
          //if(MediaQuery.of(context).size.width > webScreenSize)
          Flexible(
            child: Container(),
            flex: 2,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: 250,
            height: 20,
            child:
            const TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                prefixIcon: Icon(Icons.search),
                labelText: 'Search for user',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
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
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
    );
  }
}