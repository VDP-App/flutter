import 'package:flutter/material.dart';
import 'package:vdp/main.dart';
import 'package:vdp/utils/loading.dart';
import 'package:vdp/utils/typography.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    Key? key,
    this.subtitle,
    required this.title,
    required this.color,
    required this.onTap,
    this.isInfo = false,
    this.iconData,
    this.isLoading = false,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final Color color;
  final void Function() onTap;
  final bool isInfo;
  final IconData? iconData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isInfo) {
      return Expanded(
        child: Card(
          elevation: 8,
          color: !isTablet && isLoading ? Colors.grey : color,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: fontSizeOf.x1,
              child: TextButton(
                onPressed: isLoading ? null : onTap,
                child: Center(
                  child: Row(
                    children: [
                      if (isLoading && isTablet) loadingIconWigit,
                      T3(title, color: Colors.white),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 8,
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: isLoading
                ? loadingIconWigit.child
                : IconH1(iconData, color: Colors.white),
            onTap: isLoading ? null : onTap,
            title: H2(title, color: Colors.white),
            subtitle:
                subtitle == null ? null : T2(subtitle!, color: Colors.white70),
          ),
        ),
      ),
    );
  }
}
