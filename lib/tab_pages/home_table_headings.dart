import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iw_admin_panel/const/textstyle.dart';

class ProfilePic extends StatelessWidget {
  final double width;


  const ProfilePic({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    double containerWidth =  width <=425
        ? 70
        : width <=768 && width > 425
        ? 100
        : width <=1024&& width > 768
        ? 100
        : width <= 1440 && width > 1024
        ? 120
        : width > 1440 && width <= 2570
        ? 180 : 80;

    double fontSize = width > 1440 && width <= 2570
        ? 28 : width > 425 && width <= 768
        ? 14 : width <= 1024 && width > 768 ? 14 : width <= 1440 && width > 1024 ? 16 : 12;

    return Container(
      width: containerWidth,
      alignment: Alignment.center,
      child: Text(
        'Profile Pic',
        style: jost700(fontSize, Colors.white),
      ),
    );
  }
}

class NameContainer extends StatelessWidget {
  final double width;

  NameContainer({required this.width});

  @override
  Widget build(BuildContext context) {
    double containerWidth =  width <= 425
        ? 100
        : width <= 768 && width > 425
        ? 110
        : width <=1024 && width > 768
        ? 130
        : width <= 1440 && width > 1024
        ? 180
        : width > 1440 && width <= 2570
        ? 240 : 350;

    double fontSize = width > 1440 && width <= 2570
        ? 28 : width > 425 && width <= 768
        ? 15 : width <= 1024 && width > 768 ? 14 : width <= 1440 && width > 1024 ? 16 : 12;

    return Container(
      alignment: Alignment.center,
      width: containerWidth,
      child: Text(
        'Name',
        style: jost700(fontSize, Colors.white),
      ),
    );
  }
}

class EmailContainer extends StatelessWidget {
  final double width;

  EmailContainer({required this.width});

  @override
  Widget build(BuildContext context) {
    double containerWidth = width <= 425
        ? 190
        : width <= 768 && width > 425
        ? 220
        : width <= 1024 && width > 768
        ? 240
        : width <= 1440 && width > 1024
        ? 300
        : width > 1440 && width <= 2570
        ? 440
        : 350;

    double fontSize = width > 1440 && width <= 2570
        ? 28 : width > 425 && width <= 768
        ? 14 : width <= 1024 && width > 768 ? 14 : width <= 1440 && width > 1024 ? 16 : 12;

    return Container(
      alignment: Alignment.center,
      width: containerWidth,
      child: Text(
        'Email',
        style: jost700(fontSize, Colors.white),
      ),
    );
  }
}

class ChatBlock extends StatelessWidget {
  final double width;

  ChatBlock({required this.width});

  @override
  Widget build(BuildContext context) {
    double containerWidth =  width <= 425
        ? 110
        : width <=768 && width > 425
        ? 100
        : width <=1024 && width > 768
        ? 110
        : width <= 1440
        ? 154
        : width > 1440 && width <= 2570
        ? 240 : 150;

    double fontSize = width > 1440 && width <= 2570
        ? 28 : width > 425 && width <= 768
        ? 14 : width <= 1024 && width > 768 ? 14 : width <= 1440 && width > 1024 ? 16 : 12;

    return Container(
      alignment: Alignment.center,
      width: containerWidth,
      child: Text(
        'Chat Blocked',
        style: jost700(fontSize, Colors.white),
      ),
    );
  }
}

class BlockContainer extends StatelessWidget {
  final double width;

  BlockContainer({required this.width});

  @override
  Widget build(BuildContext context) {
    double containerWidth =  width <= 425
        ? 70
        : width <=768 && width > 425
        ? 80
        : width <=1024 && width > 768
        ? 80
        : width <= 1440
        ? 154
        : width > 1440 && width <= 2570
        ? 210 : 150;

    double fontSize = width > 1440 && width <= 2570
        ? 28 : width > 425 && width <= 768
        ? 14 : width <= 1024 && width > 768 ? 14 : width <= 1440 && width > 1024 ? 16 : 12;

    return Container(
      alignment: Alignment.center,
      width: containerWidth,
      child: Text(
        'Block',
        style: jost700(fontSize,Colors.white),
      ),
    );
  }
}

class DeleteContainer extends StatelessWidget {
  final double width;

  DeleteContainer({required this.width});

  @override
  Widget build(BuildContext context) {
    double containerWidth =  width <= 425
        ? 70
        : width <=768 && width > 425
        ? 80
        : width <=1024 && width > 768
        ? 80
        : width <= 1440
        ? 154
        : width > 1440 && width <= 2570
        ? 210 : 150;

    double fontSize = width > 1440 && width <= 2570
        ? 28 : width > 425 && width <= 768
        ? 14 : width <= 1024 && width > 768 ? 14 : width <= 1440 && width > 1024 ? 16 : 12;

    return Container(
      alignment: Alignment.center,
      width: containerWidth,
      child: Text(
        'Delete',
        style: jost700(fontSize,Colors.white),
      ),
    );
  }
}




