import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../../models/cart_model.dart';
import 'checkout_page.dart';
import '../../../../providers/user_provider.dart';
import '../../../../services/user_service/cart_service.dart';
import '../../../../../common/common.dart';
import '../../../../../common/components.dart';
import '../../../../../common/data/app_data.dart';
import '../../../../../common/data/app_language.dart';
import '../../../../../common/utils/app_text.dart';
import '../../../../../common/utils/constants.dart';
import '../../../../../config/colors.dart';
import '../../../../../locator.dart';
import '../../../../../common/shimmer_component.dart';

class CartPage extends StatefulWidget {
  static const String pageName = '/cart';
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isLoading = false;
  bool isCheckoutLoading = false;
  CartModel? _cartData; // Local cart data storage

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    setState(() {
      isLoading = true;
    });

    // Fetch cart directly and store locally
    _cartData = await CartService.getCart();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initiateCheckout() async {
    setState(() {
      isCheckoutLoading = true;
    });

    try {
      // Navigate to checkout processing page
      await Navigator.pushNamed(
        context,
        CheckoutPage.pageName,
        arguments: {
          'cartData': _cartData,
        },
      );

      // Refresh cart after returning from checkout
      await _loadCart();
    } catch (e) {
      _showErrorMessage('Error: An unexpected error occurred.');
    } finally {
      if(mounted){
      setState(() {
        isCheckoutLoading = false;
      });
      }
    }
  }

  Future<void> _removeItem(int itemId) async {
    bool success = await CartService.deleteCourse(itemId);
    if (success && mounted) {
      await _loadCart(); // Reload cart after removal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item removed from cart')),
      );
    }
  }

  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Widget _buildCartItemShimmer() {
    return Shimmer.fromColors(
      baseColor: greyE7,
      highlightColor: greyF8,
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Shimmer
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: grey33,
                  ),
                ),
                SizedBox(width: 16),
                // Content Shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: grey33,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: grey33,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: grey33,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          SizedBox(width: 4),
                          Container(
                            width: 40,
                            height: 14,
                            decoration: BoxDecoration(
                              color: grey33,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 16,
                        decoration: BoxDecoration(
                          color: grey33,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Remove Button Shimmer
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: grey33,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryShimmer() {
    return Shimmer.fromColors(
      baseColor: greyE7,
      highlightColor: greyF8,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(top: BorderSide(color: Colors.grey[300]!)),
        ),
        child: Column(
          children: [
            _buildSummaryRowShimmer('Subtotal'),
            SizedBox(height: 8),
            _buildSummaryRowShimmer('Discount'),
            SizedBox(height: 8),
            _buildSummaryRowShimmer('Tax'),
            SizedBox(height: 12),
            _buildSummaryRowShimmer('Total', isTotal: true),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: grey33,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRowShimmer(String label, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 80,
            height: isTotal ? 18 : 14,
            decoration: BoxDecoration(
              color: grey33,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            width: 100,
            height: isTotal ? 18 : 14,
            decoration: BoxDecoration(
              color: grey33,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsShimmer() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: 3, // Show 3 shimmer items
      itemBuilder: (context, index) {
        return _buildCartItemShimmer();
      },
    );
  }

  Widget _buildCachedImage(String? imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl != null && imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: greyE7,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(grey33),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: greyE7,
                  child: Icon(
                    Icons.image,
                    color: grey33,
                    size: 32,
                  ),
                ),
              )
            : Container(
                color: greyE7,
                child: Icon(
                  Icons.image,
                  color: grey33,
                  size: 32,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = _cartData?.items ?? [];
    final amounts = _cartData?.amounts;

    return directionality(
      child: Scaffold(
        appBar: appbar(
          title: appText.cart,
        ),
        body: isLoading
            ? Column(
                children: [
                  Expanded(
                    child: _buildCartItemsShimmer(),
                  ),
                  _buildSummaryShimmer(),
                ],
              )
            : items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadCart,
                          child: Text('Refresh Cart'),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _loadCart,
                          child: ListView.builder(
                            padding: EdgeInsets.all(16),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Card(
                                margin: EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Cached Item Image
                                      _buildCachedImage(item.image),
                                      SizedBox(width: 16),
                                      // Item Details
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.title ?? 'No Title',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              'By ${item.teacherName ?? 'Unknown Teacher'}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 14,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            if (item.rate != null &&
                                                item.rate != '0')
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 16,
                                                  ),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    item.rate!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            SizedBox(height: 8),
                                            Text(
                                              '${item.price?.toString() ?? '0'} IQD',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: green4B,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Remove Button
                                      IconButton(
                                        onPressed: () => _removeItem(item.id!),
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      // Summary and Checkout Section
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          border:
                              Border(top: BorderSide(color: Colors.grey[300]!)),
                        ),
                        child: Column(
                          children: [
                            if (amounts != null) ...[
                              _buildCartItemSummaryRow(
                                  'Subtotal', '${amounts.subTotal} IQD'),
                              if (amounts.totalDiscount != null &&
                                  amounts.totalDiscount! > 0)
                                _buildCartItemSummaryRow('Discount',
                                    '-${amounts.totalDiscount} IQD'),
                              if (amounts.taxPrice != null &&
                                  amounts.taxPrice! > 0)
                                _buildCartItemSummaryRow(
                                    'Tax', '${amounts.taxPrice} IQD'),
                              SizedBox(height: 8),
                              _buildCartItemSummaryRow(
                                'Total',
                                '${amounts.total} IQD',
                                isTotal: true,
                              ),
                            ],
                            SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isCheckoutLoading
                                    ? null
                                    : _initiateCheckout,
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  backgroundColor: green50,
                                ),
                                child: isCheckoutLoading
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : Text(
                                        'Proceed to Checkout',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildCartItemSummaryRow(String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? green4B : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}


