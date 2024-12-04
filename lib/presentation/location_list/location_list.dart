import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/api/response_models/location_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:flutter/material.dart';

class LocationListView extends StatefulWidget {
  final String selectedItem;
  final String selectedTitle;
  const LocationListView(
      {super.key, required this.selectedItem, required this.selectedTitle});

  @override
  State<LocationListView> createState() => _LocationListViewState();
}

class _LocationListViewState extends State<LocationListView> {
  bool isLoading = false;
  final ApiService apiService = ApiService();
  late List<Location> locationItems = [];
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;

  @override
  void initState() {
    super.initState();
    fetchLocations();
  }

  void fetchLocations() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.locationList, data);
    if (jsonResponse != null) {
      final response = LocationResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          locationItems = response.data;
        });
      } else {
        isError = true;
        errorText = response.message.join(', ');
      }
    }

    // var res = await globalBloc.doFetchLoginUserData(context, SharedPrefs().uID);
    // if (res != null) {
    //   var reposne = LocationResponse.fromJson(res);
    //   if (reposne.code == '200') {
    //     setState(() {
    //       locationItems = reposne.data;
    //     });
    //   } else {
    //     isError = true;
    //     errorText = reposne.message.join(', ');
    //   }
    // }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: isLoading
          ? const Center(child: CustomProgressIndicator())
          : isError
              ? Column(
                  children: [
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Container(
                        height: displayHeight(context) * 0.65,
                        width: displayWidth(context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: ColorManager.white),
                        child: Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Image.asset(
                                width: displayWidth(context) * 0.5,
                                ImageAssets.noRecordFoundIcon),
                            Text(errorText,
                                style: getRegularStyle(
                                    color: ColorManager.lightGrey,
                                    fontSize: FontSize.s17)),
                            const Spacer()
                          ],
                        )),
                      ),
                    ),
                  ],
                )
              : SingleChildScrollView(
                  child: SizedBox(
                    height: displayHeight(context),
                    child: Column(
                      children: [
                        SizedBox(height: topPadding),
                        SizedBox(
                          width: displayWidth(context),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 18, vertical: 10),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 18),
                                  child: Text(
                                    widget.selectedTitle,
                                    style: getBoldStyle(
                                        color: ColorManager.darkBlue,
                                        fontSize: FontSize.s20),
                                  ),
                                ),
                                const Spacer(),
                                SizedBox(
                                  // height: 30,
                                  child: CustomImageButton(
                                      imageString: ImageAssets.closeIcon,
                                      onTap: () {
                                        Navigator.pop(context);
                                      }),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 18, right: 18, bottom: 18),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListView.separated(
                                  itemCount: locationItems.length,
                                  separatorBuilder: (context, index) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0.0),
                                    child: Container(
                                      height: 1.5,
                                      decoration: BoxDecoration(
                                        color: ColorManager.primary,
                                      ),
                                    ),
                                  ),
                                  itemBuilder: (context, index) {
                                    final item = locationItems[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        title: Text(
                                          item.locationCode,
                                          style: item.locationCode ==
                                                  widget.selectedItem
                                              ? getMediumStyle(
                                                  color: ColorManager.orange2,
                                                  fontSize: FontSize.s21)
                                              : getRegularStyle(
                                                  color:
                                                      ColorManager.lightGrey2,
                                                  fontSize: FontSize.s21),
                                        ),
                                        onTap: () {
                                          SharedPrefs().selectedLocation =
                                              item.locationCode;
                                          SharedPrefs().selectedLocationID =
                                              item.locationId;
                                          showSnackBar(context,
                                              '${AppStrings.locationSelectedMessage}${item.locationCode}');
                                          Navigator.pop(
                                              context, item.locationCode);
                                        },
                                      ),
                                    );
                                  },
                                )),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
