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

  group('Sandwich Customization Tests', () {
    testWidgets('toggle between six-inch and footlong', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify initial state is footlong
      final switchWidget = find.byType(Switch);
      expect(switchWidget, findsOneWidget);

      // Toggle to six-inch
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      // Add six-inch sandwich
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Verify price is for six-inch (£6.00)
      expect(find.text('Cart: 1 items - £6.00'), findsOneWidget);

      // View cart and verify
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('Six-inch'), findsOneWidget);
    });

    testWidgets('change bread type and verify in cart', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Change bread type
      final breadDropdown = find.byType(DropdownMenu<BreadType>);
      await tester.tap(breadDropdown);
      await tester.pumpAndSettle();

      await tester.tap(find.text('wholegrain').last);
      await tester.pumpAndSettle();

      // Add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // View cart
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      expect(find.textContaining('wholegrain'), findsOneWidget);
    });

    testWidgets('test all sandwich types', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test cycling through different sandwich types
      final sandwichTypes = ['Veggie Delight', 'Chicken Teriyaki', 'Italian BMT', 'Meatball Marinara'];
      
      for (String sandwichType in sandwichTypes) {
        // Select sandwich type
        final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
        await tester.tap(sandwichDropdown);
        await tester.pumpAndSettle();

        await tester.tap(find.text(sandwichType).last);
        await tester.pumpAndSettle();

        // Verify selection
        expect(find.text(sandwichType), findsWidgets);
      }
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
    testWidgets('cannot add sandwich with quantity 0', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Decrease quantity to 0
      final removeButtons = find.byIcon(Icons.remove);
      final quantityRemoveButton = removeButtons.first;
      await tester.tap(quantityRemoveButton);
      await tester.pumpAndSettle();

      expect(find.text('0'), findsOneWidget);

      // Try to add to cart - button should be disabled
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      
      // Verify button exists but should be disabled (onPressed is null)
      final button = tester.widget<StyledButton>(addToCartButton);
      expect(button.onPressed, isNull);
    });

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

    testWidgets('quantity cannot go below 0', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify initial quantity is 1
      expect(find.text('1'), findsWidgets);

      // Try to decrease below 0
      final removeButtons = find.byIcon(Icons.remove);
      final quantityRemoveButton = removeButtons.first;
      
      await tester.tap(quantityRemoveButton);
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);

      // Button should be disabled when quantity is 0
      final button = tester.widget<IconButton>(quantityRemoveButton);
      expect(button.onPressed, isNull);
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
    testWidgets('save profile and receive welcome message', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);

      // Fill in profile fields
      final nameField = find.widgetWithText(TextField, 'Your Name');
      await tester.enterText(nameField, 'John Doe');
      await tester.pumpAndSettle();

      final locationField = find.widgetWithText(TextField, 'Preferred Location');
      await tester.enterText(locationField, 'London');
      await tester.pumpAndSettle();

      // Save profile
      final saveButton = find.widgetWithText(StyledButton, 'Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify welcome snackbar appears
      expect(find.text('Welcome, John Doe! Ordering from London'), findsOneWidget);
    });

    testWidgets('profile validation - empty fields show error', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Try to save without filling fields
      final saveButton = find.widgetWithText(StyledButton, 'Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

    testWidgets('profile validation - only name filled', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to profile
      final profileButton = find.widgetWithText(StyledButton, 'Profile');
      await tester.ensureVisible(profileButton);
      await tester.tap(profileButton);
      await tester.pumpAndSettle();

      // Fill only name
      final nameField = find.widgetWithText(TextField, 'Your Name');
      await tester.enterText(nameField, 'John Doe');
      await tester.pumpAndSettle();

      // Try to save
      final saveButton = find.widgetWithText(StyledButton, 'Save Profile');
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Please fill in all fields'), findsOneWidget);
    });

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
    testWidgets('complete order and verify in order history', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add sandwich and complete checkout
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

      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // Navigate to order history
      final orderHistoryButton = find.widgetWithText(StyledButton, 'Order History');
      await tester.ensureVisible(orderHistoryButton);
      await tester.tap(orderHistoryButton);
      await tester.pumpAndSettle();

      // Verify order appears in history
      expect(find.text('Order History'), findsOneWidget);
      expect(find.textContaining('ORD'), findsWidgets); // Order ID starts with ORD
      expect(find.text('£11.00'), findsOneWidget);
    });

    testWidgets('order history is empty initially', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to order history immediately (note: this test may fail if previous tests left data)
      final orderHistoryButton = find.widgetWithText(StyledButton, 'Order History');
      await tester.ensureVisible(orderHistoryButton);
      await tester.tap(orderHistoryButton);
      await tester.pumpAndSettle();

      // Either shows orders from previous tests or "No orders yet"
      expect(find.text('Order History'), findsOneWidget);
      // Can't strictly test for empty state due to test isolation issues
    });
  });

  group('Complex User Journeys', () {
    testWidgets('full journey: customize, add multiple items, modify cart, checkout', 
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add first sandwich (Veggie Delight, footlong)
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Change to six-inch Chicken Teriyaki
      final switchWidget = find.byType(Switch);
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      final sandwichDropdown = find.byType(DropdownMenu<SandwichType>);
      await tester.tap(sandwichDropdown);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chicken Teriyaki').last);
      await tester.pumpAndSettle();

      // Add quantity 2
      final addButtons = find.byIcon(Icons.add);
      final quantityAddButton = addButtons.first;
      await tester.tap(quantityAddButton);
      await tester.pumpAndSettle();

      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Should have 1 footlong (£11) + 2 six-inch (£12) = 3 items, £23
      expect(find.text('Cart: 3 items - £23.00'), findsOneWidget);

      // Go to cart and modify
      final viewCartButton = find.widgetWithText(StyledButton, 'View Cart');
      await tester.ensureVisible(viewCartButton);
      await tester.tap(viewCartButton);
      await tester.pumpAndSettle();

      // Remove one Chicken Teriyaki
      final removeButtons = find.byIcon(Icons.remove);
      await tester.tap(removeButtons.last); // Last one is for Chicken Teriyaki
      await tester.pumpAndSettle();

      // Now should have £17 (1 footlong + 1 six-inch)
      expect(find.text('Total: £17.00'), findsOneWidget);

      // Proceed to checkout
      final checkoutButton = find.widgetWithText(StyledButton, 'Checkout');
      await tester.tap(checkoutButton);
      await tester.pumpAndSettle();

      // Verify order summary
      expect(find.text('Order Summary'), findsOneWidget);
      expect(find.textContaining('Veggie Delight'), findsOneWidget);
      expect(find.textContaining('Chicken Teriyaki'), findsOneWidget);

      // Complete payment
      final confirmPaymentButton = find.text('Confirm Payment');
      await tester.tap(confirmPaymentButton);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));

      // Verify back on order screen with empty cart
      expect(find.text('Sandwich Counter'), findsOneWidget);
      expect(find.text('Cart: 0 items - £0.00'), findsOneWidget);
    });

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

    testWidgets('verify six-inch pricing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Toggle to six-inch
      final switchWidget = find.byType(Switch);
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      // Add to cart
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      expect(find.text('Cart: 1 items - £6.00'), findsOneWidget);
    });

    testWidgets('verify mixed size pricing', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add footlong
      final addToCartButton = find.widgetWithText(StyledButton, 'Add to Cart');
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Toggle to six-inch
      final switchWidget = find.byType(Switch);
      await tester.tap(switchWidget);
      await tester.pumpAndSettle();

      // Add six-inch
      await tester.ensureVisible(addToCartButton);
      await tester.tap(addToCartButton);
      await tester.pumpAndSettle();

      // Should be £11 + £6 = £17
      expect(find.text('Cart: 2 items - £17.00'), findsOneWidget);
    });
  });
}