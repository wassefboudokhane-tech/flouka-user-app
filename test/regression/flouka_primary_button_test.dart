import 'package:flouka/core/widgets/flouka_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';

void main() {
  testWidgets('button supplies its own Material ancestor', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(400, 800)),
        child: Sizer(
          builder: (context, orientation, deviceType) => Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children: [
                FloukaPrimaryButton(
                  onTap: () => tapped = true,
                  text: 'Continue',
                  translateKey: false,
                  width: 200,
                  height: 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    await tester.tap(find.text('Continue'));
    expect(tapped, isTrue);
  });
}
