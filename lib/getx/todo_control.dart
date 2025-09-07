import 'package:get/get.dart';

class TodoControl extends GetxController {
  var todoTitle = "".obs;
  var todoDisc = "".obs;
  var todoDateTime = Rxn<DateTime>();
}
