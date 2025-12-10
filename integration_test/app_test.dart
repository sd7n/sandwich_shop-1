import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:sandwich_shop/main.dart' as app;
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/widgets/common_widgets.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Basic Order Flow Tests', () {
    testWidgets('add a sandwich to the cart and verify it is in the cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test the initial state of the app (on the order screen)
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsWidgets);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      // Add a sandwich to the cart
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart summary updated
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Find the View Cart button to navigate to the cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify that we're on the cart screen and the sandwich is there
      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('change sandwich type and add to cart',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.pumpAndSettle();

      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('modify quantity and add to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final quantitySection = find.text('Quantity: ');
      expect(quantitySection, findsOneWidget);

      // Find the + button that's near the quantity text
      final addButtons = find.byIcon(Icons.add);
      final quantityAddButton = addButtons.first;

      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      expect(find.text('3'), findsOneWidget);

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.pumpAndSettle();

      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);
    });

    testWidgets('complete checkout flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      expect(find.text('Checkout'), findsOneWidget);
      expect(find.text('Order Summary'), findsOneWidget);

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();

      // Wait for payment processing (2 seconds + buffer)
      await tester.pump(const Duration(seconds: 3));

      // Should be back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });
  });

  group('Cart Management Tests', () {
    testWidgets('add multiple different sandwiches to cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add first sandwich (Veggie Delight)
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Change to Chicken Teriyaki
      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Add second sandwich
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify cart has 2 items
      expect(find.text('Cart: 2 items - £22.00'), findsOneWidget);

      // View cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify both sandwiches are in cart
      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
    });

    testWidgets('increment quantity in cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a sandwich
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Find and tap the + button in cart
      final addButtonInCart = find.byIcon(Icons.add);
      await tester.tap(addButtonInCart.first);
      await tester.pumpAndSettle();

      // Verify quantity increased
      expect(find.text('Qty: 2'), findsOneWidget);
      expect(find.text('Total: £22.00'), findsOneWidget);
    });

    testWidgets('decrement quantity in cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add 2 sandwiches
      final addButtons = find.byIcon(Icons.add);
      final quantityAddButton = addButtons.first;
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 2'), findsOneWidget);

      // Decrement quantity
      final removeButton = find.byIcon(Icons.remove);
      await tester.tap(removeButton.first);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Total: £11.00'), findsOneWidget);
    });

    testWidgets('remove item from cart completely', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a sandwich
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Remove item using delete button
      final deleteButton = find.byIcon(Icons.delete);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify cart is empty
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('decrement quantity to zero removes item', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a sandwich (quantity 1)
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Navigate to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Decrement to zero
      final removeButton = find.byIcon(Icons.remove);
      await tester.tap(removeButton.first);
      await tester.pumpAndSettle();

      // Verify item is removed
      expect(find.text('Your cart is empty.'), findsOneWidget);
    });
  });

  group('Edge Cases and Error Scenarios', () {
    testWidgets('checkout with empty cart shows error', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to cart without adding anything
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Verify checkout button is not shown when cart is empty
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      expect(checkoutButton, findsNothing);
    });

    testWidgets('navigate back from cart maintains cart state', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add items to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);

      // Navigate to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Navigate back
      final backButton = find.widgetWithText(StyledButton, 'Back to Order');
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify cart state is maintained
      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);
    });
  });

  group('Profile and Settings Tests', () {

    testWidgets('navigate to settings screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to settings
      final settingsButton = find.widgetWithText(StyledButton, 'Settings');
      await tester.ensureVisible(settingsButton);
      await tester.tap(settingsButton);
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Font Size'), findsOneWidget);

      // Navigate back
      final backButton = find.text('Back to Order');
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.text('Sandwich Counter'), findsOneWidget);
    });
  });

  group('Order History Tests', () {    
    testWidgets('add items, clear cart, verify empty state throughout flow',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add multiple items
      final addButtons = find.byIcon(Icons.add);
      final quantityAddButton = addButtons.first;
      await tester.tap(quantityAddButton);
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 3 items - £33.00'), findsOneWidget);

      // Go to cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Remove all items using delete button
      final deleteButton = find.byIcon(Icons.delete);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      // Verify empty state
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
      expect(find.widgetWithText(StyledButton, 'Checkout'), findsNothing);

      // Go back to order screen
      final backButton = find.widgetWithText(StyledButton, 'Back to Order');
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      // Verify cart is still empty
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });
  });

  group('Pricing Validation Tests', () {
    testWidgets('verify footlong pricing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add 1 footlong
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £11.00'), findsOneWidget);
    });
  });
}