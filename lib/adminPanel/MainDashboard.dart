import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iw_admin_panel/adminPanel/utils/firebase_utils.dart';
import 'package:iw_admin_panel/adminPanel/utils/mediaquery.dart';
import 'package:iw_admin_panel/adminPanel/utils/sizebox_extention.dart';

import 'Pages/EventCategories.dart';
import 'Pages/SpecialEventsPackage.dart';
import 'Pages/SpecialPackages.dart';
import 'Pages/TrendingEvents.dart';
import 'Pages/UpcomingEvents.dart';
import 'header.dart';
import 'images.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  String selectedDataType = 'Add Categories';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(43, 41, 41, 1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(child: Image.asset('assets/Images/nomad1.png',height: 50.h,width: 300.w,color: primaryColor,)),

              const Header(),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Color.fromRGBO(254, 165, 0, 0.68),
                          ),
                          child: Column(
                            children: [
                              3.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/owed.png',
                                  title: 'Add Categories',
                                  subTitle: 'See All',
                                  isSelected: selectedDataType == 'Add Categories',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'Add Categories';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/nursing-staff.png',
                                  title: 'upcomingEvents',
                                  subTitle: 'See All',
                                  isSelected: selectedDataType == 'upcomingEvents',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'upcomingEvents';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                imgUrl: 'assets/Images/practices.png',
                                title: 'Special Packages',
                                subTitle: 'See All',
                                isSelected: selectedDataType == 'Special Packages',
                                onPressed: () {
                                  setState(() {
                                    selectedDataType = 'Special Packages';
                                  });
                                },
                              ),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/updatedoc.png',
                                  title: 'Trending Events',
                                  subTitle: 'See All',
                                  isSelected:
                                  selectedDataType == 'trendingEvents',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'trendingEvents';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/dashbord.png',
                                  title: ' Doc\'s Expiring in 3 months',
                                  subTitle: 'See All',
                                  isSelected:
                                  selectedDataType == 'nearToExpire',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'nearToExpire';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/calender.png',
                                  title: 'Bookings',
                                  subTitle: 'See All',
                                  isSelected: selectedDataType == 'bookings',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'bookings';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/dentalChair.png',
                                  title: 'Posted jobs',
                                  subTitle: 'See All',
                                  isSelected:
                                  selectedDataType == 'currentBookings',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'currentBookings';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/dentalChair.png',
                                  title: 'Cancelled Bookings',
                                  subTitle: 'See All',
                                  isSelected:
                                  selectedDataType == 'cancelledBookings',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'cancelledBookings';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: AppAssets.scrubIcon,
                                  title: 'Eligible for scrub',
                                  subTitle: 'See All',
                                  isSelected:
                                  selectedDataType == 'eligibleForScrub',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'eligibleForScrub';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/invoices.png',
                                  title: 'All Invoices',
                                  subTitle: 'See All',
                                  isSelected: selectedDataType == 'allInvoices',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'allInvoices';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/credit-card.png',
                                  title: 'Payments',
                                  subTitle: 'See All',
                                  isSelected: selectedDataType == 'payments',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'payments';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/owed.png',
                                  title: 'Monies Owed From Practices',
                                  subTitle: 'See All',
                                  isSelected: selectedDataType == 'owesFrom',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'owesFrom';
                                    });
                                  }),
                              2.height,
                              DashboardWidget(
                                  imgUrl: 'assets/Images/owedto.png',
                                  title: 'Monies Owed to NN ',
                                  subTitle: 'See All',
                                  isSelected: selectedDataType == 'owesTo',
                                  onPressed: () {
                                    setState(() {
                                      selectedDataType = 'owesTo';
                                    });
                                  }),
                              2.height,
                              StreamBuilder(
                                  stream: FirebaseUtils.adminChatCollection
                                      .where('isRead', isEqualTo: false)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    bool hasNewMessage = false;
                                    if (snapshot.hasData &&
                                        snapshot.data!.docs.isNotEmpty) {
                                      hasNewMessage = true;
                                    }
                                    return Stack(
                                      children: [
                                        DashboardWidget(
                                            imgUrl: 'assets/Images/chat.png',
                                            title: 'Support Chats',
                                            subTitle: 'See All',
                                            isSelected:
                                            selectedDataType == 'chats',
                                            onPressed: () {
                                              setState(() {
                                                selectedDataType = 'chats';
                                              });
                                            }),
                                        if (hasNewMessage == true)
                                          Positioned(
                                            // Position the red dot indicator as needed
                                            left: 0,
                                            top: 20,
                                            child: Container(
                                              padding: const EdgeInsets.all(1),
                                              decoration: const BoxDecoration(
                                                color: redColor,
                                                shape: BoxShape.circle,
                                                //borderRadius: BorderRadius.circular(6),
                                              ),
                                              constraints: BoxConstraints(
                                                minWidth: 5.w,
                                                minHeight: 5.h,
                                              ),
                                            ),
                                          ),
                                      ],
                                    );
                                  }),
                              2.height,
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      if (selectedDataType == 'upcomingEvents')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 1.4,
                            width: MediaQuery.of(context).size.width / 1.3,
                             child: const UpcomingEvents(),
                          ),
                        ),
                      if (selectedDataType == 'Add Categories')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 450,
                            width: MediaQuery.of(context).size.width / 1.3,
                              child: const EventCategories(),
                          ),
                        ),
                      if (selectedDataType == 'Special Packages')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 1.4,
                            width: MediaQuery.of(context).size.width / 1.3,
                             child: const SpecialEventPackages(),
                          ),
                        ),
                      if (selectedDataType == 'trendingEvents')
                        Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 1.4,
                              width: MediaQuery.of(context).size.width / 1.3,
                               child: TrendingEvents(),
                            ),
                          ],
                        ),
                      if (selectedDataType == 'cancelledBookings')
                        Column(
                          children: [
                            SizedBox(
                              height: 600,
                              width: MediaQuery.of(context).size.width / 1.3,
                              // child: AllCancelledBookingViewForAdmin(),
                            ),
                          ],
                        ),
                      if (selectedDataType == 'payments')
                        Column(
                          children: [
                            SizedBox(
                              height: 600,
                              width: MediaQuery.of(context).size.width / 1.5,
                              // child: PaymentViewForAdmin(),
                            ),
                          ],
                        ),
                      if (selectedDataType == 'users')
                        Column(
                          children: [
                            SizedBox(
                              height: 600,
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: const Text("booking"),
                            ),
                          ],
                        ),
                      if (selectedDataType == 'owesFrom')
                        Column(
                          children: [
                            SizedBox(
                              height: 600,
                              width: MediaQuery.of(context).size.width / 1.5,
                              // child: OwesFromForAdmin(),
                            ),
                          ],
                        ),
                      if (selectedDataType == 'owesTo')
                        Column(
                          children: [
                            SizedBox(
                              height: 600,
                              width: MediaQuery.of(context).size.width / 1.3,
                              // child: OwesToForAdmin(),
                            ),
                          ],
                        ),
                      if (selectedDataType == 'currentBookings')
                        Column(
                          children: [
                            SizedBox(
                              height: 600,
                              width: MediaQuery.of(context).size.width / 1.3,
                              // child: CurrentBookingViewForAdmin(),
                            ),
                          ],
                        ),
                      if (selectedDataType == 'allInvoices')
                        Column(
                          children: [
                            SizedBox(
                              height: 600,
                              width: MediaQuery.of(context).size.width / 1.3,
                              // child: AllInvoicesViewForAdmin(),
                            ),
                          ],
                        ),
                      if (selectedDataType == 'chats')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width / 1.5,
                            // child: const AdminChatView(),
                          ),
                        ),
                      if (selectedDataType == 'emailVerifiedUsers')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width / 1.5,
                            // child: const EmailVerifiedUsers(),
                          ),
                        ),
                      if (selectedDataType == 'trendingDocuments')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width / 1.5,
                            // child: const AllUpdatedDocuments(),
                          ),
                        ),
                      if (selectedDataType == 'nearToExpire')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width / 1.4,
                            // child: const NearToExpireDocuments(),
                          ),
                        ),
                      if (selectedDataType == 'eligibleForScrub')
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width / 1.4,
                            // child: const ScrubEligibleView(),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class DashboardWidget extends StatelessWidget {
//   String title;
//   String subTitle;
//   VoidCallback onPressed;
//   DashboardWidget({super.key,required this.title,required this.subTitle,required this.onPressed});
//
//   @override
//   Widget build(BuildContext context) {
//     return  InkWell(
//       onTap: (){
//         onPressed();
//       },
//       child: Container(
//         height: 40,
//         width: 190,
//         decoration: const BoxDecoration(
//           color: primaryColor,
//           borderRadius: BorderRadius.all(Radius.circular(10)),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//                Text(title, style: TextStyle(fontWeight: FontWeight.w500, fontSize: 3.sp,color: whiteColor)),
//              // TextButton(onPressed:onPressed, child: Text(subTitle,style: TextStyle(
//              //   fontSize: 3.sp,color: whiteColor,
//              // ),
//              // )
//              // )
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class DashboardWidget extends StatelessWidget {
  String title;
  String subTitle;
  VoidCallback onPressed;
  String imgUrl;
  bool isSelected;

  DashboardWidget({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.onPressed,
    required this.imgUrl,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color containerColor =
    isSelected ? Color.fromRGBO(174, 156, 127, 1) : Colors.transparent;

    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 35.h,
        width: 60.w,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius:
          BorderRadius.circular(10), // You can adjust the radius as needed
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              imgUrl,
              color: isSelected ? Colors.white : Colors.black.withOpacity(0.40),
              width: 13.w,
              height: 13.h,
            ),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 3.sp,
                color: isSelected ? Colors.white : Colors.black.withOpacity(0.40),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
