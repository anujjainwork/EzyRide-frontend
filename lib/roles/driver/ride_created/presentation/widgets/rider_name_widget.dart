import 'package:ezyride_frontend/common/utils/utils.dart';
import 'package:ezyride_frontend/common/widgets/custom_text.dart';
import 'package:ezyride_frontend/roles/driver/ride_created/presentation/provider/ride_created_map_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget getEstTimeWidget(BuildContext context, List<String> riderList) {
  final rideCreatedMapProvider = Provider.of<RideCreatedMapProvider>(context);

  return PageView.builder(
    controller: PageController(viewportFraction: 0.9),
    itemCount: rideCreatedMapProvider.distDurationList.length,
    onPageChanged: (index) {
      var key = rideCreatedMapProvider.distDurationList.keys.elementAt(index);
      rideCreatedMapProvider.setId(key);
    },
    itemBuilder: (_, index) {
      var mapDirectionData = rideCreatedMapProvider.distDurationList.values.elementAt(index);
      return getEstTimeWidgetCard(context, mapDirectionData, riderList[index]);
    },
  );
}

Widget getEstTimeWidgetCard(BuildContext context, List<String> mapDirectionData, String riderName) {
  return Align(
    alignment: Alignment.bottomCenter,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 80),
      child: Opacity(
        opacity: 0.7,
        child: Container(
          height: getDynamicHeight(context, 14.5),
          width: getDynamicWidth(context, 87),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(color: Colors.black),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.only(top: 15, right: 20, left: 20, bottom: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Rider Name",
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  CustomText(
                    text: riderName,
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(
                height: getDynamicHeight(context, 0.5),
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: getDynamicHeight(context, 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Total Distance",
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  CustomText(
                    text: mapDirectionData[0],
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              SizedBox(
                height: getDynamicHeight(context, 0.5),
              ),
              Container(
                height: 1,
                color: Colors.black,
              ),
              SizedBox(
                height: getDynamicHeight(context, 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: "Est. time",
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                  CustomText(
                    text: mapDirectionData[1],
                    fontSize: 18,
                    textAlign: TextAlign.center,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
