import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import '../../../../models/checkout_model.dart';
import '../payment_status_page/payment_status_page.dart';
import '../../../../services/payment/fib_service.dart';
import '../../../../services/user_service/cart_service.dart';
import '../../../../services/user_service/user_service.dart';
import '../../../../../common/common.dart';
import '../../../../../common/components.dart';
import '../../../../../common/data/app_data.dart';
import '../../../../../common/utils/app_text.dart';
import '../../../../../common/utils/constants.dart';
import '../../../../../common/utils/currency_utils.dart';
import '../../../../../config/assets.dart';
import '../../../../../config/colors.dart';
import '../../../../../config/styles.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CheckoutPage extends StatefulWidget {
  static const String pageName = '/checkout';
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CheckoutModel? checkoutData;
  bool isLoading = true;
  bool isCreatingPayment = false;
  bool isPaymentProcessing = false;
  String? errorMessage;
  String token = '';

  // FIB Payment Data
  String? paymentId;
  String? qrCodeData;
  String? fibAppLink;

  @override
  void initState() {
    super.initState();
    if (paymentId == null) {
      _initializeFIBPayment();
    }
    _loadCheckoutData();
    getToken();
  }

  getToken() async {
    if (!mounted) return;
    AppData.getAccessToken().then((value) {
      if (mounted) {
        setState(() {
          token = value;
        });
      }
    });
  }

  Future<void> _loadCheckoutData() async {
    if (!mounted) return;

    if (mounted) {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });
    }
    try {
      checkoutData = await CartService.checkout();

      if (checkoutData == null) {
        throw Exception('Failed to load checkout data');
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Error loading checkout: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> _initializeFIBPayment() async {
    if (!mounted) return;
    if (checkoutData == null) return;
    if (mounted) {
      setState(() {
        isCreatingPayment = true;
        errorMessage = null;
      });
    }
    try {
      // final totalAmount = checkoutData!.amounts!.total!;
      final totalAmount = checkoutData!.amounts!.total!;

      // Use your actual callback URL
      final callbackUrl =
          "${Constants.dommain}/public/fib/mob_payment_callback.php";

      final paymentResult = await FIBPaymentService.createPayment(
        amount: totalAmount.toDouble(),
        callbackUrl: callbackUrl,
      );

      if (paymentResult['success']) {
        if (mounted) {
          setState(() {
            paymentId = paymentResult['paymentId'];
            qrCodeData = paymentResult['qrCode'];
            fibAppLink = paymentResult['personalAppLink'];
            isCreatingPayment = false;
          });
        }
        // Start monitoring payment status immediately
        // This will detect payments made by scanning QR code on other devices
        _startPaymentStatusCheck();
      } else {
        if (mounted) {
          setState(() {
            errorMessage = paymentResult['error'];
            isCreatingPayment = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = 'Payment initialization failed: $e';
          isCreatingPayment = false;
        });
      }
    }
  }

// Modified _openFIBApp - no longer needs to start checking since it's already running
  Future<void> _openFIBApp() async {
    if (!mounted) return;

    if (fibAppLink == null) {
      _showError('No payment link available');
      return;
    }

    try {
      final launched = await launchUrlString(
        fibAppLink!,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _redirectToFIBInstall();
      }
    } catch (e) {
      _showError('Cannot open FIB app: $e');
    }
  }

  void _startPaymentStatusCheck() {
    if (!mounted) return;

    print('Starting payment status check for paymentId: $paymentId');

    if (mounted) {
      setState(() {
        isPaymentProcessing = true;
      });
    }

    // Check every 3 seconds for faster response
    Future.delayed(Duration(seconds: 3), () {
      _checkPaymentStatus();
    });
  }

  Future<void> _checkPaymentStatus() async {
    if (!mounted) return;
    if (paymentId == null || !isPaymentProcessing) return;

    try {
      final statusResult =
          await FIBPaymentService.checkPaymentStatus(paymentId!);

      if (statusResult['success']) {
        final status = statusResult['status'];

        if (status == 'PAID') {
          print('FIB Payment PAID detected, confirming purchase...');

          // Payment confirmed by FIB - Now confirm purchase
          if (checkoutData?.order?.id != null) {
            final orderId = checkoutData!.order!.id!;

            // Call direct purchase confirmation
            final purchaseResult = await FIBPaymentService.confirmPurchase(
                paymentId!, orderId.toString(), token.toString());

            print('Purchase confirmation result: ${purchaseResult['success']}');

            if (purchaseResult['success'] == true) {
              // Refresh cart and handle success
              await CartService.getCart();
              _handlePaymentSuccess();
            } else {
              final errorMsg = purchaseResult['error'] ?? 'Unknown error';
              _handlePaymentFailure(
                  'Payment successful but purchase failed: $errorMsg');
            }
          } else {
            _handlePaymentFailure('Payment successful but no order ID found');
          }
        } else if (status == 'DECLINED' || status == 'FAILED') {
          _handlePaymentFailure('Payment was declined or failed');
        } else if (status == 'PENDING' || status == 'CREATED') {
          // Continue checking for pending payments
          print('Payment status: $status - continuing to check...');
          _startPaymentStatusCheck();
        } else {
          print('Unknown payment status: $status - continuing to check...');
          _startPaymentStatusCheck();
        }
      } else {
        print('Status check failed: ${statusResult['error']} - retrying...');
        _startPaymentStatusCheck();
      }
    } catch (e) {
      print('Status check error: $e - retrying...');
      _startPaymentStatusCheck();
    }
  }

  void _handlePaymentSuccess() {
    if (!mounted) return;

    print('Payment and purchase completed successfully!');

    if (mounted) {
      setState(() {
        isPaymentProcessing = false;
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment completed successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to success page
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, PaymentStatusPage.pageName,
          arguments: {
            'status': 'success',
            'message': 'Payment completed successfully',
            'orderId': checkoutData?.order?.id?.toString() ?? '',
          });
    });
  }

  void _handlePaymentFailure(String message) {
    if (!mounted) return;
    if (mounted) {
      setState(() {
        isPaymentProcessing = false;
        errorMessage = message;
      });
    }
  }
  // Future<void> _openFIBApp() async {
  //   if (fibAppLink == null) {
  //     _showError('No payment link available');
  //     return;
  //   }

  //   try {
  //     final launched = await launchUrlString(
  //       fibAppLink!,
  //       mode: LaunchMode.externalApplication,
  //     );

  //     if (!launched) {
  //       _redirectToFIBInstall();
  //     }
  //   } catch (e) {
  //     _showError('Cannot open FIB app: $e');
  //   }
  // }

  Future<void> _redirectToFIBInstall() async {
    if (!mounted) return;

    const androidUrl =
        'https://play.google.com/store/apps/details?id=com.firstiraqibank.personal';
    const iosUrl =
        'https://apps.apple.com/us/app/first-iraqi-bank/id1545549339';

    final storeUrl =
        Theme.of(context).platform == TargetPlatform.iOS ? iosUrl : androidUrl;

    try {
      await launchUrlString(storeUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      _showError('Cannot redirect to app store');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildPaymentSection() {
    if (isCreatingPayment) {
      return _buildLoadingState('Creating payment...');
    }

    if (isPaymentProcessing) {
      return _buildPaymentInterface();
    }

    if (paymentId == null) {
      return _buildPaymentInitialization();
    }

    return _buildPaymentInterface();
  }

  Widget _buildPaymentInitialization() {
    return GestureDetector(
      onTap: () => _initializeFIBPayment(),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xff00a69c), width: 1),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.all(0),
        child: Image.asset(
          AppAssets.fibJpg,
          width: 300,
          height: 120,
        ),
      ),
    );
  }

  Widget _buildPaymentInterface() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Scan QR Code with FIB App',
            style: style16Bold(),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),

          // QR Code
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: QrImageView(
              data: fibAppLink ?? '',
              version: QrVersions.auto,
              size: 100.0,
            ),
          ),

          SizedBox(height: 10),

          // OR Divider
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('OR', style: style14Bold()),
              ),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: 20),

          // Open FIB App Button
          Container(
            width: 200,
            height: 45,
            decoration: BoxDecoration(
              color: Color(0xff00a69c),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: _openFIBApp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AppAssets.fibLogoIcon,
                    width: 40,
                    height: 40,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Open FIB App',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitRing(
                      color: Colors.orange,
                      size: 20,
                      lineWidth: 3,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Processing Payment...',
                      style: style16Bold(),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Please wait while we confirm your payment',
                  style: style14Regular(),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Please do not exit the app until payment process is success',
                  style: style14Regular(),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Container(
          //   width: double.infinity,
          //   padding: EdgeInsets.all(16),
          //   decoration: BoxDecoration(
          //     color: Colors.blue[50],
          //     borderRadius: BorderRadius.circular(12),
          //     border: Border.all(color: Color(0xff7bdcb5)),
          //   ),
          //   child: Column(
          //     children: [
          //       Image.asset(
          //         AppAssets.fibLogoPng,
          //         width: 60,
          //         height: 60,
          //       ),
          //       SizedBox(height: 12),
          //       Text(
          //         'Open FIB Bank App',
          //         style: style16Bold(),
          //       ),
          //       SizedBox(height: 12),
          //       button(
          //         onTap: _openFIBApp,
          //         width: 200,
          //         height: 45,
          //         text: 'Open FIB App',
          //         bgColor: Color(0xff00a69c),
          //         textColor: Colors.white,
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(String message) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(message, style: style14Regular()),
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    if (checkoutData == null) return SizedBox();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('Order Summary', style: style16Bold()),
          SizedBox(height: 12),
          _buildSummaryRow('Subtotal', checkoutData!.amounts!.subTotal ?? 0),
          if ((checkoutData!.amounts!.totalDiscount ?? 0) > 0)
            _buildSummaryRow(
                'Discount', checkoutData!.amounts!.totalDiscount ?? 0,
                isDiscount: true),
          if ((checkoutData!.amounts!.taxPrice ?? 0) > 0)
            _buildSummaryRow('Tax', checkoutData!.amounts!.taxPrice ?? 0),
          Divider(),
          _buildSummaryRow('Total', checkoutData!.amounts!.total ?? 0,
              isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, num amount,
      {bool isTotal = false, bool isDiscount = false}) {
    final formattedAmount =
        CurrencyUtils.calculator(amount.toDouble()).seRagham();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: isTotal ? style16Bold() : style14Regular()),
          Text(
            isDiscount ? '-$formattedAmount' : formattedAmount,
            style: isTotal
                ? style16Bold().copyWith(color: green77())
                : style14Regular(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return directionality(
      child: Scaffold(
        appBar: appbar(title: appText.paymentMethod),
        body: isLoading
            ? Center(child: loading())
            : errorMessage != null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          style: style16Regular(),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        button(
                          onTap: _loadCheckoutData,
                          width: 200,
                          height: 50,
                          text: 'Try Again',
                          bgColor: green77(),
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildOrderSummary(),
                        SizedBox(height: 20),
                        _buildPaymentSection(),
                      ],
                    ),
                  ),
      ),
    );
  }
}
