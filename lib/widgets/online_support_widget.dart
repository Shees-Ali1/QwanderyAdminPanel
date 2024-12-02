import 'package:flutter/material.dart';
import 'package:iw_admin_panel/colors.dart';
import 'package:iw_admin_panel/const/textstyle.dart';

class OnlineSupportWidget extends StatefulWidget {
  const OnlineSupportWidget({
    super.key, 
    required this.profile_pic, 
    required this.name, 
    required this.email,
    required this.bio,
    required this.profile_type,
    required this.is_verified
  });
  
  final String profile_pic;
  final String name;
  final String email;
  final String bio;
  final String profile_type;
  final bool is_verified;

  @override
  State<OnlineSupportWidget> createState() => _OnlineSupportWidgetState();
}

class _OnlineSupportWidgetState extends State<OnlineSupportWidget> {



  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;

    double fontSize = width <= 425 && width > 375
        ? 14
        : width <= 768 && width > 425
        ? 13
        : width <= 1024 && width >768
        ? 11
        : width <= 1440 && width > 1024
        ? 14
        : width > 1440 && width <= 2570
        ? 15
        : 12;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.blueColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.lighterBlueColor,
            blurRadius: 6.0,
            offset: Offset(1, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.lighterBlueColor,
                backgroundImage: NetworkImage(widget.profile_pic),
              ),
              SizedBox(width: 10,),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(widget.name, style: jost500(fontSize, Colors.white),),
                      if(widget.is_verified == true)
                        SizedBox(width: 4,),
                      if(widget.is_verified == true)
                        Image.asset('assets/images/qwandery-verified-professional.png', height: 15, width: 15,)
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text(widget.email, style: jost500(fontSize, Colors.white),),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}
