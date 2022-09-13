import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/dimensions.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../ressources/firestone_methods.dart';
import '../screens/comments_screen.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {

  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState(){
    super.initState();
    getComments();
  }

  void getComments() async {
    try{
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();
      commentLen = snap.docs.length;
    }catch(e){
      showSnackBar(e.toString(), context);
    }
    if(mounted) setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider
        .of<UserProvider>(context)
        .getUser;
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: width > webScreenSize ? secondaryColors : mobileBackgroundColor,
        ),
        color: mobileBackgroundColor,
      ),
      padding: const EdgeInsets.symmetric(
          vertical: 10
      ),
      child: Column(
        children: [
          //HEADER SECTION
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    widget.snap['profImage'],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                widget.snap['uid'].toString() == user.uid
                    ? IconButton(
                        onPressed: () {
                          showDialog( useRootNavigator: false, context: context, builder: (context) =>
                              Dialog(
                                child: ListView(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shrinkWrap: true,
                                  children: [
                                    'Delete',
                                  ].map((e) =>
                                      InkWell(
                                        onTap: () async {
                                          FirestoreMethods().deletePost(widget.snap['postId']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16
                                          ),
                                          child: Text(e),
                                        ),
                                      ),
                                  ).toList(),
                                ),
                              ));
                        },
                        icon: const Icon(
                            Icons.more_vert
                        ),
                      ) : Container(),
              ],
            ),
          ),
          //IMAGE SECTION
          GestureDetector(
              onDoubleTap: () async {
                await FirestoreMethods().likePost(
                  widget.snap['postId'],
                  user.uid,
                  widget.snap['likes'],
                );
                if(mounted) setState(() {
                  isLikeAnimating = true;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'],
                      fit: BoxFit.cover,
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(
                      milliseconds: 200,
                    ),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      child: const Icon(
                        Icons.favorite,
                        color: primaryColor,
                        size: 100,
                      ),
                      isAnimating: isLikeAnimating,
                      duration: const Duration(
                        milliseconds: 400,
                      ),
                      onEnd: () {
                        if(mounted) setState(() {
                          isLikeAnimating = false;
                        });
                      },
                    ),
                  ),
                ],
              ),
          ),
          //LIKE COMMENT SECTION
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FirestoreMethods().likePost(
                      widget.snap['postId'],
                      user.uid,
                      widget.snap['likes'],
                    );
                  },
                  icon: widget.snap['likes'].contains(user.uid)
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                      )
                      : const Icon(
                          Icons.favorite_border,
                      ),
                  ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CommentsScreen(
                      snap: widget.snap,
                    ),
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              )
            ],
          ),
          // DESCRIPTION AND NUMBER OF COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme
                      .of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText2,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                          color: primaryColor,
                        ),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                          ),
                        ]
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          ),
                        ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    child: Text(
                      'View all $commentLen comments',
                      style: const TextStyle(
                        fontSize: 16,
                        color: secondaryColors,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ),
                  child: Text(
                    DateFormat.yMMMd().format(
                      widget.snap['datePublished'].toDate(),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColors,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}


