/**
 * switch 组件，基础使用Tween动画效果，使用stack堆叠多层，后面一层为switch的两极，前一层为动画
 * author: djytwy on 2021/8/5 20:23
 */

import 'package:flutter/material.dart';

class Switch extends StatefulWidget {
  final tapCB;
  final List activeList;
  final String active;
  final Color bgColor;
  final TextStyle innerTextStyle;

  const Switch({
    Key ? key,
    required this.activeList,
    required this.active,
    this.tapCB,
    this.bgColor = const Color(0xFFC9C9C9),
    this.innerTextStyle = const TextStyle(color: Colors.black,fontSize: 14)
  }) : super(key: key);

  @override
  _SwitchState createState() => _SwitchState();
}

class _SwitchState extends State<Switch> with SingleTickerProviderStateMixin {
  var activeIndex = 0;
  late String activeText;
  late List activeList;

  late final AnimationController controller = AnimationController(
    duration: Duration(milliseconds: 100) ,
    vsync: this
  );

  late final animationRight = Tween(begin: Offset.zero, end: Offset(1,0)).animate(controller);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    activeText = widget.active;
    activeList = widget.activeList;

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          activeIndex = activeIndex == 0 ? 1 : 0;
          activeText = activeList[activeIndex];
          widget.tapCB(activeIndex);
        });
      } else if ( status == AnimationStatus.dismissed ) {
        setState(() {
          activeIndex = activeIndex == 0 ? 1 : 0;
          activeText = activeList[activeIndex];
          widget.tapCB(activeIndex);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: EdgeInsets.only(left: 20, right: 20, bottom: 35),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(90)),
        color: widget.bgColor
      ),
      child: Stack(
        children: [
          // 后面一层
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.reverse();
                  },
                  child: Center(
                    child: Text(activeList[0], style: widget.innerTextStyle),
                  )
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.forward();
                  },
                  child: Center(
                    child: Text(activeList[1], style: widget.innerTextStyle),
                  )
                )
              )
            ],
          ),
          // 前面的一层，为动画效果
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SlideTransition(
                  position: animationRight,
                  child: Container(
                    height: 43,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(90)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(.5, .5),
                          blurRadius: 0,
                          spreadRadius: 0
                        )
                      ]
                    ),
                    child: Center(
                      child: Text(
                        activeText,
                        style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                )
              ),
              Expanded(
                child: Center(
                  child: Text(''),
                ),
              )
            ],
          )
        ],
      )
    );
  }
}
