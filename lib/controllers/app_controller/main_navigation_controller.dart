import 'package:get/get.dart';
import '../../controllers/search_controller.dart';

class MainNavigationController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool shouldFocusSearch = false.obs;
  bool _appliedInitialTabFromArgs = false;

  void changeTab(int index, {bool focusSearch = false}) {
    if (index >= 0 && index <= 4) {
      currentIndex.value = index;

      // If navigating to search tab (index 2) and focusSearch is true, trigger focus
      if (index == 2 && focusSearch) {
        shouldFocusSearch.value = true;
        // Reset after a short delay
        Future.delayed(const Duration(milliseconds: 200), () {
          shouldFocusSearch.value = false;
        });

        // Request focus on search field
        if (Get.isRegistered<SearchViewController>()) {
          Get.find<SearchViewController>().requestFocus();
        }
      }
    }
  }

  /// Apply initial tab from route arguments once (e.g. after publish -> open My Listings tab).
  void applyInitialTabFromArguments() {
    if (_appliedInitialTabFromArgs) return;
    final args = Get.arguments;
    if (args is Map && args['tabIndex'] != null) {
      final index = args['tabIndex'] as int;
      if (index >= 0 && index <= 4) {
        currentIndex.value = index;
      }
      _appliedInitialTabFromArgs = true;
    }
  }
}

