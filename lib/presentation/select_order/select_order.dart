import 'dart:async';

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/response_models/order_response.dart';
import 'package:eyvo_inventory/app/app_prefs.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/constants.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/utils.dart';
import 'package:eyvo_inventory/core/widgets/custom_field.dart';
import 'package:eyvo_inventory/core/widgets/progress_indicator.dart';
import 'package:eyvo_inventory/presentation/received_item_list/received_item_list.dart';
import 'package:flutter/material.dart';

class SelectOrderView extends StatefulWidget {
  const SelectOrderView({super.key});

  @override
  State<SelectOrderView> createState() => _SelectOrderViewState();
}

class _SelectOrderViewState extends State<SelectOrderView> {
  Timer? _debounce;
  late ScrollController _scrollController;
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  bool isLoading = false;
  bool isLoadMore = false;
  String searchText = '';
  final ApiService apiService = ApiService();
  late List<Order> orderItems = [];
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  int page = 1;
  int totalRecords = AppConstants.totalRecords;
  int pageSize = AppConstants.pageSize;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _scrollController = ScrollController()..addListener(_scrollListener);
    fetchOrders(false);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      fetchOrders(true);
    }
  }

  void fetchOrders(bool isLoadingMoreItems) async {
    if (isLoading || isLoadMore || orderItems.length >= totalRecords) return;
    setState(() {
      isLoading = !isLoadingMoreItems && !isSearching;
      isLoadMore = isLoadingMoreItems;
    });

    Map<String, dynamic> data = {
      'uid': SharedPrefs().uID,
      'search': searchController.text,
      'regionid': SharedPrefs().selectedRegionID,
      'pageno': page,
      'pagesize': AppConstants.pageSize
    };
    final jsonResponse = await apiService.postRequest(
        context, ApiService.goodReceiveOrderList, data);
    if (jsonResponse != null) {
      final response = OrderResponse.fromJson(jsonResponse);
      if (response.code == '200') {
        setState(() {
          isError = false;
          if (isLoadingMoreItems) {
            orderItems.addAll(response.data);
          } else {
            orderItems = response.data;
          }
          totalRecords = response.totalRecords;
          page++;
        });
      } else {
        orderItems = [];
        isError = true;
        errorText = response.message.join(', ');
      }
    }

    setState(() {
      isLoading = false;
      isSearching = false;
      isLoadMore = false;
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _onSearchChanged() {
    if ((searchController.text.length >= 3 &&
            searchText != searchController.text &&
            searchController.text.isNotEmpty) ||
        searchText.isNotEmpty) {
      setState(() {
        searchText = searchController.text;
        isSearching = true;
        page = 1;
        totalRecords = 10000000;
      });
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 550), () {
        fetchOrders(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        appBar: AppBar(
          backgroundColor: ColorManager.darkBlue,
          title: Text(AppStrings.selectOrder,
              style: getBoldStyle(
                  color: ColorManager.white, fontSize: FontSize.s27)),
          leading: IconButton(
            icon: Image.asset(ImageAssets.backButton),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading && !isSearching
            ? const Center(child: CustomProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    CustomSearchField(
                        controller: searchController,
                        placeholderText: AppStrings.searchOrderNumber),
                    const SizedBox(height: 20),
                    isError
                        ? Expanded(
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
                          )
                        : Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorManager.white,
                              ),
                              child: orderItems.isEmpty &&
                                      !isLoading &&
                                      !isLoadMore
                                  ? Center(
                                      child: Text(errorText,
                                          style: getRegularStyle(
                                              color: ColorManager.black,
                                              fontSize: FontSize.s27)))
                                  : NotificationListener<ScrollNotification>(
                                      onNotification:
                                          (ScrollNotification notification) {
                                        if (notification
                                            is ScrollStartNotification) {
                                          FocusScope.of(context).unfocus();
                                        }
                                        return false;
                                      },
                                      child: ListView.separated(
                                        controller: _scrollController,
                                        itemCount: orderItems.length + 1,
                                        separatorBuilder: (context, index) =>
                                            Padding(
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
                                          if (index == orderItems.length) {
                                            if (orderItems.length >=
                                                totalRecords) {
                                              return const SizedBox();
                                            }
                                            return const Center(
                                                child:
                                                    CustomProgressIndicator());
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ListTile(
                                              title: Text(
                                                  orderItems[index].orderNumber,
                                                  style: getSemiBoldStyle(
                                                      color: ColorManager.black,
                                                      fontSize:
                                                          FontSize.s27_75)),
                                              onTap: () {
                                                navigateToScreen(
                                                    context,
                                                    ReceivedItemListView(
                                                      orderNumber:
                                                          orderItems[index]
                                                              .orderNumber,
                                                      orderId: orderItems[index]
                                                          .orderId,
                                                    ));
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
