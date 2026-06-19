import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:memorise/app.dart';
import 'package:memorise/data/quiz_questions.dart';
import 'package:memorise/widgets/bubble_title.dart';

void main() {
  test('the whole app widget tree compiles', () {
    // Referencing MemoriseApp forces the test compiler to build every screen
    // (app.dart transitively imports all screens/widgets) to kernel.
    expect(const MemoriseApp().runtimeType, MemoriseApp);
  });

  test('there are exactly 30 questions across 3 levels', () {
    final questions = QuizQuestions.getQuestions();
    expect(questions.length, 30);
    for (var lvl = 1; lvl <= 3; lvl++) {
      expect(questions.where((q) => q.levelId == lvl).length, 10);
    }
  });

  test('every question has a valid correct answer index', () {
    for (final q in QuizQuestions.getQuestions()) {
      expect(q.correctAnswerIndex, inInclusiveRange(0, q.options.length - 1));
    }
  });

  testWidgets('BubbleTitle renders its text', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: BubbleTitle())));
    expect(find.text('MEMORY CHALLENGE'), findsNWidgets(2));
  });
}
