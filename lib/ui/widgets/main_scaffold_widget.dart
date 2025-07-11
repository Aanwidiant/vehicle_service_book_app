import 'package:flutter/material.dart';
import 'package:vehicle_service_book_app/ui/widgets/user_menu_widget.dart';

class MainScaffoldWidget extends StatelessWidget {
  final String title;
  final Widget body;
  final bool showProfileOption;
  final bool showBackButton;

  const MainScaffoldWidget({
    super.key,
    required this.title,
    required this.body,
    this.showProfileOption = true,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: UserMenuWidget(showProfileOption: showProfileOption),
          ),
        ],
      ),
      body: body,
    );
  }
}
