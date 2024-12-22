import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';

class SidebarController extends GetxController{
  RxBool chat = false.obs;
  RxInt selectedindex =0.obs;
  RxBool showsidebar =false.obs;
  var controller = SidebarXController(selectedIndex: 0, extended: true);

  RxString selectedTab = "Users".obs;
  RxString selectedDrawer = "Simple".obs;
}