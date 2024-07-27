import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pedia_predict/utils/database_helper.dart';

// Database Helper Provider
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

// Question State and Notifier
class QuestionState {
  final Map<String, String> answers;
  final Map<String, TextEditingController> textControllers;

  QuestionState(this.answers, this.textControllers);
}

class QuestionNotifier extends StateNotifier<QuestionState> {
  QuestionNotifier() : super(QuestionState({}, {}));

  void setAnswer(String questionKey, String answer) {
    state = QuestionState({
      ...state.answers,
      questionKey: answer,
    }, state.textControllers);
  }

  TextEditingController? getController(String questionKey) {
    return state.textControllers[questionKey];
  }

  void setController(String questionKey, TextEditingController controller) {
    state.textControllers[questionKey] = controller;
  }

  void clearAnswers() {
    state = QuestionState({}, {});
  }

  void disposeAll() {
    for (var controller in state.textControllers.values) {
      controller.dispose();
    }
    state = QuestionState({}, {});
  }
}

// Keep the provider alive without auto-disposing
final questionProvider = StateNotifierProvider<QuestionNotifier, QuestionState>(
  (ref) {
    final notifier = QuestionNotifier();
    ref.onDispose(() {
      notifier.disposeAll();
    });
    return notifier;
  },
);

// Habits State and Notifier
class PsssHabitsState {
  final Map<dynamic, String> choices;

  PsssHabitsState({this.choices = const {}});

  PsssHabitsState copyWith({Map<dynamic, String>? choices}) {
    return PsssHabitsState(
      choices: choices ?? this.choices,
    );
  }
}

class PsssHabitsNotifier extends StateNotifier<PsssHabitsState> {
  PsssHabitsNotifier() : super(PsssHabitsState());

  void setChoice(dynamic category, String choice) {
    state = state.copyWith(choices: {
      ...state.choices,
      category: choice,
    });
  }

  void disposeAll() {
    state = PsssHabitsState();
  }
}

// Providers for different habits
final physicalHabitsProvider = StateNotifierProvider<PsssHabitsNotifier, PsssHabitsState>(
  (ref) {
    final notifier = PsssHabitsNotifier();
    ref.onDispose(() {
      notifier.disposeAll();
    });
    return notifier;
  },
);

final sedentaryHabitsProvider = StateNotifierProvider<PsssHabitsNotifier, PsssHabitsState>(
  (ref) {
    final notifier = PsssHabitsNotifier();
    ref.onDispose(() {
      notifier.disposeAll();
    });
    return notifier;
  },
);

final mentalHabitsProvider = StateNotifierProvider<PsssHabitsNotifier, PsssHabitsState>(
  (ref) {
    final notifier = PsssHabitsNotifier();
    ref.onDispose(() {
      notifier.disposeAll();
    });
    return notifier;
  },
);

final sleepHabitsProvider = StateNotifierProvider<PsssHabitsNotifier, PsssHabitsState>(
  (ref) {
    final notifier = PsssHabitsNotifier();
    ref.onDispose(() {
      notifier.disposeAll();
    });
    return notifier;
  },
);

final eatingHabitsProvider = StateNotifierProvider<PsssHabitsNotifier, PsssHabitsState>(
  (ref) {
    final notifier = PsssHabitsNotifier();
    ref.onDispose(() {
      notifier.disposeAll();
    });
    return notifier;
  },
);

// Image Selection State and Notifier
class ImageSelectionState {
  final int? selectedRating;

  ImageSelectionState({this.selectedRating});
}

class ImageSelectionNotifier extends StateNotifier<ImageSelectionState> {
  ImageSelectionNotifier() : super(ImageSelectionState());

  void setSelectedRating(int rating) {
    state = ImageSelectionState(selectedRating: rating);
  }

  void disposeAll() {
    state = ImageSelectionState(selectedRating: null);
  }
}

// Image Providers
final imageProvider1 = StateNotifierProvider<ImageSelectionNotifier, ImageSelectionState>(
  (ref) {
    final notifier = ImageSelectionNotifier();
    ref.onDispose(() {
      notifier.disposeAll();
    });
    return notifier;
  },
);

final imageProvider2 = StateNotifierProvider<ImageSelectionNotifier, ImageSelectionState>(
  (ref) {
    final notifier = ImageSelectionNotifier();
    ref.onDispose(() {
      notifier.disposeAll();
    });
    return notifier;
  },
);

class ProviderManager {
  // This method should be called to reset all providers
  static void resetAllProviders(WidgetRef ref) {
    ref.read(questionProvider.notifier).disposeAll();
    ref.read(physicalHabitsProvider.notifier).disposeAll();
    ref.read(sedentaryHabitsProvider.notifier).disposeAll();
    ref.read(mentalHabitsProvider.notifier).disposeAll();
    ref.read(sleepHabitsProvider.notifier).disposeAll();
    ref.read(eatingHabitsProvider.notifier).disposeAll();
    ref.read(imageProvider1.notifier).disposeAll();
    ref.read(imageProvider2.notifier).disposeAll();
  }
}