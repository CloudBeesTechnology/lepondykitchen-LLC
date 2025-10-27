import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_web/model/module_model.dart';

class WebModuleCategoryWidget extends StatefulWidget {
  final ModuleModel moduleModel;

  const WebModuleCategoryWidget({super.key, required this.moduleModel});

  @override
  State<WebModuleCategoryWidget> createState() =>
      _WebModuleCategoryWidgetState();
}

class _WebModuleCategoryWidgetState extends State<WebModuleCategoryWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      onTap: () {
        context.go(widget.moduleModel.route);
      },
      onHover: (value) {
        setState(() {
          isHovered = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: Container(
                height: 100,
                width: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  // border: Border.all(color: appColor, width: 5),
                ),
                child: Transform.scale(
                  scale: MediaQuery.of(context).size.width >= 1100
                      ? (isHovered ? 1.3 : 1.0)
                      : (isHovered ? 1 : 1.0),
                  child: Center(
                    child: Image.asset(
                      height: 50,
                      width: 50,
                      widget.moduleModel.image,
                      scale: 8,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                widget.moduleModel.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
