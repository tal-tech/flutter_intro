import 'package:flutter/material.dart';
///include real view,and warp onClick, when click mask's height light Widget,it call this.onTap
class ShadowView extends StatelessWidget{
  final Widget child;
  final VoidCallback? onTap;
  VoidCallback? get onClick=>onTap;
  const ShadowView({Key? key, this.onTap, required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return child;
  }

}