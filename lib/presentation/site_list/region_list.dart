// ignore_for_file: use_build_context_synchronously

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/region_response.dart';
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

class RegionListView extends StatefulWidget {
  final String selectedItem;
  final String selectedTitle;
  const RegionListView(
      {super.key, required this.selectedItem, required this.selectedTitle});

  @override
  State<RegionListView> createState() => _RegionListViewState();
}

class _RegionListViewState extends State<RegionListView> {
  bool isLoading = false;
  final ApiService apiService = ApiService();
  late List<Region> regionItems = [];
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;

  @override
  void initState() {
    super.initState();
    fetchRegions();
  }

  void fetchRegions() async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
    };
    final jsonResponse =
        await apiService.postRequest(context, ApiService.regionList, data);
    if (jsonResponse != null) {
      final response = RegionResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          regionItems = response.data;
        });
      } else {
        isError = true;
        errorText = response.message.join(', ');
      }
    }

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
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 18),
                                child: Text(
                                  widget.selectedTitle,
                                  style: getBoldStyle(
                                      color: ColorManager.darkBlue,
                                      fontSize: FontSize.s31_5),
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                height: 30,
                                child: CustomImageButton(
                                    imageString: ImageAssets.closeIcon,
                                    onTap: () {
                                      Navigator.pop(context);
                                    }),
                              )
                            ],
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
                                  itemCount: regionItems.length,
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
                                    final item = regionItems[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: ListTile(
                                        title: Text(item.regionCode,
                                            style: item.regionCode ==
                                                    widget.selectedItem
                                                ? getMediumStyle(
                                                    color: ColorManager.orange2,
                                                    fontSize: FontSize.s23_25)
                                                : getRegularStyle(
                                                    color:
                                                        ColorManager.lightGrey2,
                                                    fontSize: FontSize.s23_25)),
                                        onTap: () {
                                          SharedPrefs().selectedRegion =
                                              item.regionCode;
                                          SharedPrefs().selectedRegionID =
                                              item.regionId;
                                          showSnackBar(context,
                                              '${AppStrings.siteSelectedMessage}${item.regionCode}');
                                          Navigator.pop(
                                              context, item.regionCode);
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
