import 'package:flutter/material.dart';
import 'package:get/get.dart';

const double myResponsiveWidth = 350,
    myResponsiveHeight = 700,
    myDefaultMaxWidth = 700,
    myDefaultMinWidth = 300;

class MyResponsiveScreen extends StatefulWidget {
  const MyResponsiveScreen({super.key, required this.screen});
  final Widget screen;

  @override
  State<MyResponsiveScreen> createState() => _MyResponsiveScreenState();
}

class _MyResponsiveScreenState extends State<MyResponsiveScreen> {
  ScrollController horizontalController = ScrollController();
  ScrollController verticalController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return (context.width >= myResponsiveWidth &&
            context.height >= myResponsiveHeight)
        ? widget.screen
        : (context.width < myResponsiveWidth &&
                context.height < myResponsiveHeight)
            ? Scrollbar(
                interactive: true,
                controller: horizontalController,
                child: SingleChildScrollView(
                  controller: horizontalController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Scrollbar(
                        interactive: true,
                        controller: verticalController,
                        child: SingleChildScrollView(
                          controller: verticalController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              SizedBox(
                                width: myResponsiveWidth,
                                height: myResponsiveHeight,
                                child: widget.screen,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : (context.width < myResponsiveWidth)
                ? Scrollbar(
                    interactive: true,
                    controller: horizontalController,
                    child: SingleChildScrollView(
                      controller: horizontalController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: myResponsiveWidth,
                        child: widget.screen,
                      ),
                    ),
                  )
                : Scrollbar(
                    interactive: true,
                    controller: verticalController,
                    child: SingleChildScrollView(
                      controller: verticalController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: SizedBox(
                        height: myResponsiveHeight,
                        child: widget.screen,
                      ),
                    ),
                  );
  }
}
