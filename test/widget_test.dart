import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slushbuster/main.dart';
import 'package:slushbuster/config/constants/app_constants.dart';

void main() {
  testWidgets('App should render correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed
    expect(find.text(AppConstants.appName), findsOneWidget);

    // Verify that the shopping cart icon is present
    expect(find.byIcon(Icons.shopping_cart), findsOneWidget);
  });
}
