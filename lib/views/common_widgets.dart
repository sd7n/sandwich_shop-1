import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/app_styles.dart';

/// A common AppBar widget used across all screens in the app.
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCartIndicator;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showCartIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
      title: Text(
        title,
        style: heading1,
      ),
      actions: showCartIndicator
          ? [
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shopping_cart),
                        const SizedBox(width: 4),
                        Text('${cart.countOfItems}'),
                      ],
                    ),
                  );
                },
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// A styled button widget with consistent appearance across the app.
class StyledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final Color backgroundColor;

  const StyledButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    ButtonStyle myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: Colors.white,
      textStyle: normalText,
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: myButtonStyle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

/// A cart summary widget displaying total items and price.
class CartSummaryText extends StatelessWidget {
  const CartSummaryText({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        return Text(
          'Cart: ${cart.countOfItems} items - £${cart.totalPrice.toStringAsFixed(2)}',
          style: normalText,
          textAlign: TextAlign.center,
        );
      },
    );
  }
}
