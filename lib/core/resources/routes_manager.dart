import 'package:eyvo_inventory/features/auth/view/screens/company_code/company_code.dart';
import 'package:eyvo_inventory/log_data.dart/logger_data.dart';
import 'package:eyvo_inventory/presentation/change_password/change_password.dart';
import 'package:eyvo_inventory/presentation/create_pin/create_pin.dart';
import 'package:eyvo_inventory/presentation/pdf_view/pdf_view.dart';
import 'package:eyvo_inventory/presentation/email_sent/email_sent.dart';
import 'package:eyvo_inventory/presentation/enter_pin/enter_pin.dart';
import 'package:eyvo_inventory/presentation/enter_user_id/enter_user_id.dart';
import 'package:eyvo_inventory/presentation/forgot_password/forgot_password.dart';
import 'package:eyvo_inventory/presentation/forgot_user_id/forgot_user_id.dart';
import 'package:eyvo_inventory/presentation/home/home.dart';
import 'package:eyvo_inventory/presentation/item_details/item_details.dart';
import 'package:eyvo_inventory/presentation/item_list/item_list.dart';
import 'package:eyvo_inventory/features/auth/view/screens/login/login.dart';
import 'package:eyvo_inventory/presentation/location_list/location_list.dart';
import 'package:eyvo_inventory/presentation/password_changed/password_changed.dart';
import 'package:eyvo_inventory/presentation/pin_changed/pin_changed.dart';
import 'package:eyvo_inventory/presentation/received_item_list/received_item_list.dart';
import 'package:eyvo_inventory/core/resources/strings_manager.dart';
import 'package:eyvo_inventory/presentation/reset_password/reset_password.dart';
import 'package:eyvo_inventory/presentation/select_order/select_order.dart';
import 'package:eyvo_inventory/presentation/set_pin/set_pin.dart';
import 'package:eyvo_inventory/presentation/site_list/region_list.dart';
import 'package:eyvo_inventory/presentation/splash/splash.dart';
import 'package:eyvo_inventory/presentation/verify_email/verify_email.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class Routes {
  static const String splashRoute = "/";
  static const String companyCodeRoute = "/companyCode";
  static const String loginRoute = "/login";
  static const String forgotUserIDRoute = "/forgotUserID";
  static const String emailSentRoute = "/emailSent";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String enterUserIDRoute = "/enterUserID";
  static const String verifyEmailRoute = "/verifyEmail";
  static const String resetPasswordRoute = "/resetPassword";
  static const String passwordChangedRoute = "/passwordChanged";
  static const String pinChangedRoute = "/pinChanged";
  static const String createPINRoute = "/createPIN";
  static const String enterPINRoute = "/enterPIN";
  static const String setPINRoute = "/setPIN";
  static const String homeRoute = "/home";
  static const String changePasswordRoute = "/changePassword";
  static const String regionListRoute = "/regionList";
  static const String locationListRoute = "/locationList";
  static const String itemDetailsRoute = "/itemDetails";
  static const String itemsInOutRoute = "/itemsInOut";
  static const String itemListRoute = "/itemList";
  static const String selectOrderRoute = "/selectOrder";
  static const String searchOrderRoute = "/searchOrder";
  static const String receivedItemListRoute = "/receivedItemList";
  static const String pdfViewRoute = "/pdfView";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    LoggerData.dataLog('Navigate Screen : $routeSettings');
    switch (routeSettings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.companyCodeRoute:
        return MaterialPageRoute(builder: (_) => const CompanyCodeView());
      case Routes.loginRoute:
        return MaterialPageRoute(builder: (_) => const LoginViewPage());
      case Routes.forgotUserIDRoute:
        return MaterialPageRoute(
            builder: (_) => const ForgotUserIDView(), fullscreenDialog: true);
      case Routes.emailSentRoute:
        return MaterialPageRoute(
            builder: (_) => const EmailSentView(), fullscreenDialog: true);
      case Routes.forgotPasswordRoute:
        return MaterialPageRoute(
            builder: (_) => const ForgotPasswordView(), fullscreenDialog: true);
      case Routes.enterUserIDRoute:
        return MaterialPageRoute(
            builder: (_) => const EnterUserIDView(), fullscreenDialog: true);
      case Routes.verifyEmailRoute:
        return MaterialPageRoute(
            builder: (_) => const VerifyEmailView(userName: ''),
            fullscreenDialog: true);
      case Routes.resetPasswordRoute:
        return MaterialPageRoute(
            builder: (_) => const ResetPasswordView(), fullscreenDialog: true);
      case Routes.passwordChangedRoute:
        return MaterialPageRoute(builder: (_) => const PasswordChangedView());
      case Routes.pinChangedRoute:
        return MaterialPageRoute(builder: (_) => const PinChangedView());
      case Routes.createPINRoute:
        return MaterialPageRoute(builder: (_) => const CreatePINView());
      case Routes.enterPINRoute:
        return MaterialPageRoute(builder: (_) => const EnterPINView());
      case Routes.setPINRoute:
        return MaterialPageRoute(builder: (_) => const SetPINView());
      case Routes.homeRoute:
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.changePasswordRoute:
        return MaterialPageRoute(builder: (_) => const ChangePasswordView());
      case Routes.regionListRoute:
        return MaterialPageRoute(
            builder: (_) =>
                const RegionListView(selectedItem: '', selectedTitle: ''));
      case Routes.locationListRoute:
        return MaterialPageRoute(
            builder: (_) =>
                const LocationListView(selectedItem: '', selectedTitle: ''));
      case Routes.itemDetailsRoute:
        return MaterialPageRoute(
            builder: (_) => const ItemDetailsView(itemId: 0));
      case Routes.itemListRoute:
        return MaterialPageRoute(builder: (_) => const ItemListView());
      case Routes.selectOrderRoute:
        return MaterialPageRoute(builder: (_) => const SelectOrderView());
      case Routes.receivedItemListRoute:
        return MaterialPageRoute(
            builder: (_) => const ReceivedItemListView(
                  orderNumber: '',
                  orderId: 0,
                ));
      case Routes.pdfViewRoute:
        return MaterialPageRoute(
            builder: (_) => const PDFViewScreen(
                  orderNumber: '',
                  orderId: 0,
                  itemId: 0,
                  grNo: "",
                ));
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text(AppStrings.noRouteFound),
              ),
              body: const Center(
                child: Text(AppStrings.noRouteFound),
              ),
            ));
  }
}
