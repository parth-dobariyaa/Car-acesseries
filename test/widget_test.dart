import 'package:flutter_test/flutter_test.dart';
import 'package:car_accessories/main.dart';

void main() {
  testWidgets('Carvora auth screen loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const CarvoraApp());
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('CARVORA'), findsWidgets);
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('REGISTER'), findsOneWidget);
    expect(find.text('ADMIN LOGIN'), findsOneWidget);
  });
}
