import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bottom_navigation_controller.g.dart';

@riverpod
class BottomNavigationController extends _$BottomNavigationController {
  @override
  int build() {
    return 0;
  }

  void changeIndex(int index) {
    if (state != index) state = index;
  }
}
