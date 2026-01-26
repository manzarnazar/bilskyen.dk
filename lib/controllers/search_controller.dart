import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchViewController extends GetxController {
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchTextController = TextEditingController();

  void requestFocus() {
    // Use a small delay to ensure the widget is built
    Future.delayed(const Duration(milliseconds: 100), () {
      if (searchFocusNode.canRequestFocus) {
        searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    searchTextController.dispose();
    super.onClose();
  }
}
