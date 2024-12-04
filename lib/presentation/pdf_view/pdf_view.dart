import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:eyvo_inventory/api/api_service/api_service.dart';
import 'package:eyvo_inventory/api/api_service/bloc.dart';
import 'package:eyvo_inventory/app/sizes_helper.dart';
import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:eyvo_inventory/core/resources/color_manager.dart';
import 'package:eyvo_inventory/core/resources/font_manager.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/core/resources/styles_manager.dart';
import 'package:eyvo_inventory/core/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

class PDFViewScreen extends StatefulWidget {
  final String orderNumber;
  final int orderId;
  final int itemId;
  final String grNo;
  const PDFViewScreen(
      {super.key,
      required this.orderNumber,
      required this.orderId,
      required this.itemId,
      required this.grNo});

  @override
  State<PDFViewScreen> createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  String? filePath;
  int _totalPages = 0;
  int _currentPage = 0;
  late Uint8List pdfBytes;
  bool isLoading = false;
  bool isError = false;
  String errorText = AppStrings.somethingWentWrong;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  void loadPdf() async {
    setState(() {
      isLoading = true;
    });

    // Map<String, dynamic> data = {
    //   'orderid': widget.orderId,
    //   'grnno': widget.grNo
    // };
    // final jsonResponse = await apiService.postRequest(
    //     context, ApiService.goodReceivePrint, data);
    // if (jsonResponse != null) {
    //   final response = DefaultAPIResponse.fromJson(jsonResponse);
    //   if (response.code == '200') {
    //     String base64Data = response.data;
    //     pdfBytes = base64Decode(base64Data);
    //     final output = await getTemporaryDirectory();
    //     final file = File("${output.path}/${widget.orderId}.pdf");
    //     await file.writeAsBytes(pdfBytes);
    //     setState(() {
    //       filePath = file.path;
    //     });
    //   } else {
    //     isError = true;
    //     errorText = response.message.join(', ');
    //   }
    // }
    var res = await globalBloc.doFetchPdfData(context,
        orderId: widget.orderId, grNo: widget.grNo);

    if (res.code == '200') {
      String base64Data = res.data;
      pdfBytes = base64Decode(base64Data);
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/${widget.orderId}.pdf");
      await file.writeAsBytes(pdfBytes);
      setState(() {
        filePath = file.path;
      });
    } else {
      isError = true;
      errorText = res.message.join(', ');
    }
    setState(() {
      isLoading = false;
    });
  }

  void printPDF() async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.darkBlue,
        title: Text(AppStrings.orderNumberDetail + widget.orderNumber,
            style: getBoldStyle(
                color: ColorManager.white, fontSize: FontSize.s27)),
        leading: IconButton(
          icon: Image.asset(ImageAssets.backButton),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: isLoading && filePath == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                PDFView(
                  filePath: filePath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  onRender: (pages) {
                    setState(() {
                      _totalPages = pages!;
                    });
                  },
                  onViewCreated: (PDFViewController pdfViewController) {},
                  onPageChanged: (int? page, int? total) {
                    setState(() {
                      _currentPage = page!;
                    });
                  },
                ),
                if (_totalPages > 0)
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      color: Colors.black54,
                      child: Text(
                        'Page ${_currentPage + 1} of $_totalPages',
                        style: getRegularStyle(
                            color: ColorManager.white, fontSize: FontSize.s16),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: displayWidth(context),
                    height: 120,
                    color: ColorManager.white,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: CustomButton(
                          buttonText: AppStrings.print,
                          onTap: () {
                            printPDF();
                          },
                          isEnabled: true),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
