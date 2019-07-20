library expandable_dialogs;

import 'package:flutter/material.dart';

class ExpandableDialog {
  static show({
    BuildContext context,
    Widget child,
    double topPadding = 100.0,
    double bottomPadding = 16.0,
    double leftPadding = 16.0,
    double rightPadding = 16.0,
    bool verticalOnly = true,
  }) {
    Widget expDialog = ExpDialog(
      child: child,
      topPadding: topPadding,
      padding: Padding(
        padding: EdgeInsets.only(
          top: topPadding,
          bottom: bottomPadding,
          left: leftPadding,
          right: rightPadding,
        ),
      ),
      verticalOnly: verticalOnly,
    );
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'label',
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, pAnim, sAnim) {
          return expDialog;
        },
        transitionBuilder: (context, pAnim, sAnim, child) {
          return FadeTransition(
            opacity: pAnim,
            child: child,
          );
        });
  }
}

class ExpDialog extends StatefulWidget {
  final Widget child;
  final double topPadding;
  final Padding padding;
  final bool verticalOnly;

  const ExpDialog({
    Key key,
    this.child,
    this.padding,
    this.topPadding,
    this.verticalOnly = true,
  }) : super(key: key);

  @override
  _ExpDialogState createState() => _ExpDialogState();
}

class _ExpDialogState extends State<ExpDialog> with TickerProviderStateMixin {
  AnimationController _returnBackController;
  Animation<Offset> _returnBackAnimation;
  Offset _dialogPositionOffset;
  Offset _dragStartOffset;
  Padding _padding;
  bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = false;
    _padding = widget.padding;
    _dialogPositionOffset = Offset.zero;
    _returnBackController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addListener(() {
        setState(() {
          _dialogPositionOffset = _returnBackAnimation.value;
        });
      });
  }

  @override
  void dispose() {
    _returnBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialog = Padding(
      padding: _padding.padding,
      child: SafeArea(
        child: Transform.translate(
          offset: _dialogPositionOffset,
          child: ExpandableStatus(
            isExpanded: _expanded,
            child: widget.child,
          ),
        ),
      ),
    );
    if (!_expanded) {
      return GestureDetector(
        onVerticalDragStart: _onVerticalDragStart,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: dialog,
      );
    } else {
      return dialog;
    }
  }

  void _onVerticalDragStart(DragStartDetails details) {
    _dragStartOffset = details.globalPosition;
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      widget.verticalOnly
          ? _dialogPositionOffset =
              Offset(0.0, details.globalPosition.dy - _dragStartOffset.dy)
          : _dialogPositionOffset = details.globalPosition - _dragStartOffset;
      if (_dialogPositionOffset.dy < -widget.topPadding) {
        _padding = Padding(padding: EdgeInsets.zero);
        _expanded = true;
        _animateBack();
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    _animateBack();
  }

  void _animateBack() {
    _returnBackAnimation = Tween(begin: _dialogPositionOffset, end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _returnBackController, curve: Curves.elasticOut));
    _returnBackController.forward(from: 0.0);
  }
}

class ExpandableStatus extends InheritedWidget {
  final bool isExpanded;

  ExpandableStatus({this.isExpanded, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static ExpandableStatus of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(ExpandableStatus);
}
