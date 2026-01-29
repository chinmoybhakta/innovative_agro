import 'dart:math';

class ChallengeGenerator {
  static final Random _random = Random();
  static int _lastGeneratedTime = 0;

  // Prevent too frequent generation
  static bool get _canGenerateNew {
    final now = DateTime.now().millisecondsSinceEpoch;
    return now - _lastGeneratedTime > 2000; // 2 seconds minimum
  }

  static Map<String, dynamic> generateMathChallenge() {
    if (!_canGenerateNew) {
      return {
        'question': 'Please wait before requesting a new challenge',
        'answer': 'wait',
        'type': 'wait',
      };
    }

    _lastGeneratedTime = DateTime.now().millisecondsSinceEpoch;

    final operations = ['+', '-', '*'];
    final operation = operations[_random.nextInt(operations.length)];

    int num1, num2;

    switch (operation) {
      case '+':
        num1 = _random.nextInt(15) + 5;
        num2 = _random.nextInt(15) + 5;
        break;
      case '-':
        num1 = _random.nextInt(20) + 10;
        num2 = _random.nextInt(num1 - 5) + 1;
        break;
      case '*':
        num1 = _random.nextInt(9) + 2;
        num2 = _random.nextInt(9) + 2;
        break;
      default:
        num1 = _random.nextInt(10) + 1;
        num2 = _random.nextInt(10) + 1;
    }

    final answer = _calculateAnswer(num1, num2, operation);

    return {
      'question': 'What is $num1 $operation $num2?',
      'answer': answer.toString(),
      'hint': 'Solve the math problem',
      'type': 'math',
    };
  }

  static Map<String, dynamic> generateSimpleChallenge() {
    if (!_canGenerateNew) {
      return {
        'question': 'Please wait...',
        'answer': 'wait',
        'type': 'wait',
      };
    }

    _lastGeneratedTime = DateTime.now().millisecondsSinceEpoch;

    final challenges = [
      {
        'question': 'What is 3 + 4?',
        'answer': '7',
        'hint': 'Basic addition',
      },
      {
        'question': 'What is 10 - 3?',
        'answer': '7',
        'hint': 'Basic subtraction',
      },
      {
        'question': 'Type the word "human"',
        'answer': 'human',
        'hint': 'Exactly as shown',
      },
      {
        'question': 'What comes after 5?',
        'answer': '6',
        'hint': 'Next number',
      },
      {
        'question': 'Spell "cat"',
        'answer': 'cat',
        'hint': 'Three letters',
      },
    ];

    return challenges[_random.nextInt(challenges.length)];
  }

  static int _calculateAnswer(int a, int b, String operation) {
    switch (operation) {
      case '+': return a + b;
      case '-': return a - b;
      case '*': return a * b;
      default: return a + b;
    }
  }
}