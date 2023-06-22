import 'package:flutter/material.dart';
import 'package:my_team/pages/chat_page.dart';
import 'package:my_team/pages/group_page.dart';
import 'package:my_team/widgets/widgets.dart';
import 'dart:math';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({
    super.key,
    required this.userName,
    required this.groupId,
    required this.groupName
    });

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> with TickerProviderStateMixin{

  late final AnimationController _controller = AnimationController(vsync: this,lowerBound: -.5,upperBound: 0, duration: Duration(seconds: 1));
  double circleAvatarRadius = 30;
  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: ListTile(
          onTap: (){
            nextScreen(context, GroupPage(
              groupId: widget.groupId, groupName: widget.groupName, userName: widget.userName
            ));
            },
          leading: AnimatedBuilder(
            animation: _controller ,
            builder: (context, child) {
              return Transform(
                transform: Matrix4.rotationX(pi*(_controller.value)),
                origin: Offset(circleAvatarRadius,circleAvatarRadius-2),
                child: child,
              );
            },
            child: CircleAvatar(
              radius: circleAvatarRadius,
              backgroundColor: myColor,
              child: Text(widget.groupName.substring(0,1).toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)
            ),
          ),
          title: Text(widget.groupName, style: const TextStyle(fontWeight: FontWeight.bold),),
          // subtitle: Text(widget.groupName),
        ),
      );
  }
}