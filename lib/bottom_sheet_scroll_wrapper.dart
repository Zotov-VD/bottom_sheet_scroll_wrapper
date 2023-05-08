library bottom_sheet_scroll_wrapper;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _minFlingVelocity = 700.0;
const double _closeProgressThreshold = 0.5;

class BottomSheetScrollWrapper extends StatefulWidget {
  const BottomSheetScrollWrapper({
    super.key,
    required this.child,
  });

  final Widget child;
  @override
  State<BottomSheetScrollWrapper> createState() =>
      _BottomSheetScrollWrapperState();
}

class _BottomSheetScrollWrapperState extends State<BottomSheetScrollWrapper> {
  late final ScrollController _scrollController;
  late final AnimationController _animationController;
  late final State<BottomSheet> _bottomSheetState;
  final VelocityTracker _vt = VelocityTracker.withKind(PointerDeviceKind.touch);

  bool get _dismissUnderway =>
      _animationController.status == AnimationStatus.reverse;

  @override
  void initState() {
    super.initState();
    final bottomSheet = context.findAncestorWidgetOfExactType<BottomSheet>()!;
    _animationController = bottomSheet.animationController!;
    _bottomSheetState = context.findAncestorStateOfType<State<BottomSheet>>()!;
    _scrollController = ScrollController();
  }

  double get _sheetHeight {
    final RenderBox renderBox =
        _bottomSheetState.context.findRenderObject()! as RenderBox;
    return renderBox.size.height;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) =>
          _vt.addPosition(event.timeStamp, event.position),
      onPointerMove: (event) {
        if (event.down &&
            _scrollController.positions.isNotEmpty &&
            _scrollController.position.pixels <= 0.0) {
          if (_dismissUnderway) {
            return;
          }
          _animationController.value -= event.delta.dy / _sheetHeight;
        }
        _vt.addPosition(event.timeStamp, event.position);
      },
      onPointerUp: (event) {
        if (_scrollController.positions.isNotEmpty &&
            _scrollController.position.pixels <= 0.0) {
        } else {
          return;
        }
        if (_dismissUnderway) {
          return;
        }
        final velocity = _vt.getVelocity();
        bool isClosing = false;
        if (velocity.pixelsPerSecond.dy > _minFlingVelocity) {
          final double flingVelocity =
              -velocity.pixelsPerSecond.dy / _sheetHeight;
          if (_animationController.value > 0.0) {
            _animationController.fling(velocity: flingVelocity);
          }
          if (flingVelocity < 0.0) {
            isClosing = true;
          }
        } else if (_animationController.value < _closeProgressThreshold) {
          if (_animationController.value > 0.0) {
            _animationController.fling(velocity: -1.0);
          }
          isClosing = true;
        } else {
          _animationController.forward();
        }
        //         widget.onDragEnd?.call(
        //   details,
        //   isClosing: isClosing,
        // );

        // if (isClosing) {
        //   widget.onClosing();
        // }
      },
      child: PrimaryScrollController(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }
}
