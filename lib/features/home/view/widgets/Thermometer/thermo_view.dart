import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sls_mvp_microsoft/core/widgets/custom_container.dart';
import 'package:sls_mvp_microsoft/features/home/view/widgets/Thermometer/widgets/thermo_view_body.dart';
class ThermoView extends StatelessWidget {
  const ThermoView({super.key, required this.val});
final num val;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 500,
      height: 380,
      child: ThermoViewBody(val: val,),
    );
  }
}
