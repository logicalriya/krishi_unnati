import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:krishi_unnati/screens/farmers/farmer_dashboard.dart';
import 'package:krishi_unnati/screens/farmers/farmer_login_page.dart';
import 'package:krishi_unnati/welcome/registration_help_page.dart';
import 'package:krishi_unnati/state/app_locale.dart';
import 'package:krishi_unnati/state/app_session.dart';
import 'package:krishi_unnati/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('header shows current user information and settings action',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'ku_session': jsonEncode({
        'fullName': 'Asha Patil',
        'phone': '9876543210',
        'role': 'farmer',
        'village': 'Nashik',
        'district': 'Nashik',
        'farmSize': '2.5',
        'primaryCrop': 'Wheat',
        'avatarPath': '',
      }),
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: AppLocaleProvider(
          child: AppSessionProvider(
            child: HomePage(),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Krishi Unnati'), findsOneWidget);
    expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
  });

  testWidgets('farmer login screen uses the active app locale',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AppLocaleProvider(
          child: AppSessionProvider(
            child: Builder(
              builder: (context) {
                return const FarmerLoginPage();
              },
            ),
          ),
        ),
      ),
    );

    final locale = AppLocale.of(tester.element(find.byType(FarmerLoginPage)));
    locale.setLanguage(AppLanguage.hindi);
    await tester.pump();

    expect(find.text('साइन इन करें'), findsOneWidget);
  });

  testWidgets('registration help screen uses the active app locale',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AppLocaleProvider(
          child: AppSessionProvider(
            child: const RegistrationHelpPage(),
          ),
        ),
      ),
    );

    final locale = AppLocale.of(
      tester.element(find.byType(RegistrationHelpPage)),
    );
    await locale.setLanguage(AppLanguage.hindi);
    await tester.pump();

    expect(find.text('पंजीकरण कैसे करें'), findsOneWidget);
    expect(find.text('किसान पंजीकरण चुनें'), findsOneWidget);
    expect(find.text('अगला चरण'), findsOneWidget);
  });

  testWidgets('saved farmer session opens the farmer dashboard',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({
      'ku_session': jsonEncode({
        'fullName': 'Asha Patil',
        'phone': '9876543210',
        'role': 'farmer',
      }),
    });

    await tester.pumpWidget(
      const MaterialApp(
        home: AppLocaleProvider(
          child: AppSessionProvider(
            child: AppEntryPage(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Krishi Unnati'), findsOneWidget);
  });
}
