import 'package:dashboard_template/components/header.dart';
import 'package:flutter/material.dart';

class CoordinatorLayout extends StatefulWidget {
  CoordinatorLayout({
    Key key,
    this.header,
    this.body,
    this.scrollController,
    this.snap = true,
    this.overlap = false,
  }) : super(key: key);
  final SliverCollapseHeader header;
  final Widget body;
  final ScrollController scrollController;
  final bool snap;
  final bool overlap;
  @override
  _CoordinatorLayoutState createState() => _CoordinatorLayoutState();
}

class _CoordinatorLayoutState extends State<CoordinatorLayout> {
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return buildNestedScrollView();
  }

  Widget buildNestedScrollView() {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification) {
          double range = widget.header.maxHeight - widget.header.minHeight;
          if (scrollController.offset > 0 && scrollController.offset < range) {
            if (scrollController.offset < range / 2) {
              scrollController
                  .animateTo(0,
                      duration: Duration(milliseconds: 100), curve: Curves.ease)
                  .then((value) => scrollController.jumpTo(0));
            } else if (scrollController.offset < range) {
              scrollController
                  .animateTo(range,
                      duration: Duration(milliseconds: 100), curve: Curves.ease)
                  .then((value) => scrollController.jumpTo(range));
            }
          }
        }
        return false;
      },
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          List<Widget> children = [
            widget.header,
          ];
          return children;
        },
        body: Container(
          child: SingleChildScrollView(
            child: widget.body,
          ),
        ),
      ),
    );
  }
}
