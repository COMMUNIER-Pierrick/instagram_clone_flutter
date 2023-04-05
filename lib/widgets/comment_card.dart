import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../ressources/firestone_methods.dart';
import 'like_animation.dart';

class CommentCard extends StatefulWidget {
  final dynamic snap;
  const CommentCard({ Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {

  @override
  Widget build(BuildContext context) {

    final User user = Provider
        .of<UserProvider>(context)
        .getUser;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                        children: [
                          TextSpan(
                            text: widget.snap['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['text']}',
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Row(
                      children: [
                        Text(
                          DateFormat.yMMMd().format(widget.snap['datePublished'].toDate(),),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        if(widget.snap['likes'].length > 0)
                        Text(
                            '${widget.snap['likes'].length} likes',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          LikeAnimation(
            isAnimating: widget.snap['likes'].contains(user.uid),
            smallLike: true,
            child: IconButton(
              onPressed: () async {
                await FirestoreMethods().likeComment(
                  widget.snap['postId'],
                  widget.snap['commentId'],
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
        ],
      ),
    );
  }
}