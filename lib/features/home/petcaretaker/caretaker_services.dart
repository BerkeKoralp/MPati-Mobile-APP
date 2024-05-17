import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/service_container.dart';
class CaretakerServices extends StatelessWidget {
  const CaretakerServices({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShowCareRequestsButton(
              name: "Show Care Requests",
              iconPath: "assets/images/requests.png",
              width: 150,
              height: 150,
            ),
            ChatService(
              name: "Chat",
              iconPath: "assets/images/chats.png",
              width: 150,
              height: 150,)
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            PreviousSessionsButton(
              name: "Previous Sessions",
              iconPath: "assets/images/sessions.png",
              width: 150,
              height: 150,
            ),
            CaretakerBillsButton(
              name: "Show Bills of Past Services",
              iconPath: "assets/images/bills.png",
              width: 150,
              height: 150,
            ),
          ],
        ),
      ],
    );
  }
}
class ChatService extends StatelessWidget {
  const ChatService({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    required this.iconPath,
  });

  final String name;
  final double height;
  final double width;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(
      iconPath: iconPath,
      nameOfBox: name,
      onPressed: () {
        Routemaster.of(context).push('/contact-page');
      },
      height: height,
      width: width,
    );
  }
}
class ShowCareRequestsButton extends StatelessWidget {
  const ShowCareRequestsButton({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    required this.iconPath,
  });

  final String name;
  final double height;
  final double width;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(
      iconPath: iconPath,
      nameOfBox: name,
      onPressed: () {
        Routemaster.of(context).push('/show-care-requests');
      },
      height: height,
      width: width,
    );
  }
}

class PreviousSessionsButton extends StatelessWidget {
  const PreviousSessionsButton({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    required this.iconPath,
  });

  final String name;
  final double height;
  final double width;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(
      iconPath: iconPath,
      nameOfBox: name,
      onPressed: () {
        Routemaster.of(context).push('/previous-sessions');
      },
      height: height,
      width: width,
    );
  }
}

class CaretakerBillsButton extends StatelessWidget {
  const CaretakerBillsButton({
    super.key,
    required this.name,
    required this.height,
    required this.width,
    required this.iconPath,
  });

  final String name;
  final double height;
  final double width;
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return ServiceBox(
      iconPath: iconPath,
      nameOfBox: name,
      onPressed: () {
        Routemaster.of(context).push('/show-bills');
      },
      height: height,
      width: width,
    );
  }
}