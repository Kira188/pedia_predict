//Eating_habits data
enum EatingCategory {
  cereals,
  pulsesAndLegumes,
  vegetables,
  fruits,
  milkAndMilkProducts,
  nonVegetarian,
  snacks,
  sweets,
  beverages,
  others,
}
const List<String> eatingFrequencyOptions = [
  'Never',
  'Rarely',
  'Sometimes',
  'Often',
  'Almost Always',
];
const List<String> eatingCategoryNames = [
  'Cereals',
  'Pulses and Legumes',
  'Vegetables',
  'Fruits',
  'Milk and Milk Products',
  'Non-Vegetarian Food Products',
  'Snacks',
  'Sweets and Deserts',
  'Beverages',
  'Others',
];
class EatingData {
  Map<EatingCategory, String> choices = {};

  EatingData();

  int get calculatedEatingScore {
    int score = 0;
    for (String frequency in choices.values) {
      switch (frequency) {
        case 'Never':
          score += 0;
          break;
        case 'Rarely':
          score += 1;
          break;
        case 'Sometimes':
          score += 2;
          break;
        case 'Often':
          score += 3;
          break;
        case 'Almost Always':
          score += 4;
          break;
      }
    }
    return score;
  }
}

// Physical Habits Data
enum PhysicalCategory {
  dance,
  swimming,
  yoga,
  exercise,
  indoor,
  outdoor,
  play,
  self,
  walking,
}

const List<String> physicalFrequencyOptions = [
  'Never',
  '1 day',
  '2 days',
  '3 days',
  '4 days',
  '5 days',
  '6 days',
  '7 days',
];

const List<String> physicalCategoryNames = [
  'Dance',
  'Swimming',
  'Yoga',
  'Exercise',
  'Indoor games: table tennis, badminton, etc.',
  'Outdoor games: cricket, football, kho kho, etc.',
  'Play after school hours',
  'Self (Bicycle)',
  'Walking',
];

class PhysicalData {
  Map<PhysicalCategory, String> choices = {};

  PhysicalData();

  int get calculatedPhysicalScore {
    int score = 0;
    for (String frequency in choices.values) {
      if (frequency == 'Never') {
        score += 0;
      } else if (frequency == '1 day') {
        score += 1;
      } else if (frequency == '2 days') {
        score += 2;
      } else if (frequency == '3 days') {
        score += 3;
      } else if (frequency == '4 days') {
        score += 4;
      } else if (frequency == '5 days') {
        score += 5;
      } else if (frequency == '6 days') {
        score += 6;
      } else if (frequency == '7 days') {
        score += 7;
      } 
    }
    return score;
  }
}

// Sedentary Habits Data
enum SedentaryCategory {
  tv,
  mobile,
  readingSchool,
  readingNonSchool,
  indoor,
  outdoor,
  tuition,
}

const List<String> sedentaryFrequencyOptions = [
  'Never',
  '< 1 Hr/ Day',
  '1 - 2 Hrs/Day',
  '2 - 3 Hrs/ Day',
  '>3 Hrs/ Day',
];

const List<String> sedentaryCategoryNames = [
  'Watching TV/videos/ movies/shows/ theatres',
  'Using mobile/ internet/ social media/ mobile games, Chatting, listening to music etc.,',
  'Reading and writing school related like Homework, textbook, notes, assignments, projects etc.,',
  'Non-school related  reading and writing - a book or magazine not for school (including comic books), writing articles, etc.,',
  'Playing indoor games Carrom, pacchi, ludo, snake and ladder, chess, etc.,',
  'Playing outdoor games antyakshari, dam sharads, business games, etc.,',
  'Tuition classes after school',
];

class SedentaryData {
  Map<SedentaryCategory, String> choices = {};

  SedentaryData();

  int get calculatedSedentaryScore {
    int score = 0;
    for (String frequency in choices.values) {
      switch (frequency) {
        case 'Never':
          score += 0;
          break;
        case '< 1 Hr/ Day':
          score += 1;
          break;
        case '1 - 2 Hrs/Day':
          score += 2;
          break;
        case '2 - 3 Hrs/ Day':
          score += 3;
          break;
        case '>3 Hrs/ Day':
          score += 4;
          break;
      }
    }
    return score;
  }
}

// Sedentary Habits Data Two
enum SedentaryCategoryTwo {
  walk,
  run,
  sports,
  attention,
  forget,
  studies,
  lonely,
  weight,
}

const List<String> sedentaryFrequencyOptionsTwo = [
  'Never',
  'Rarely',
  'Sometimes',
  'Often',
  'Almost Always',
];

const List<String> sedentaryCategoryNamesTwo = [
  'It is hard for me to walk',
  'It is hard for me to run',
  'It is hard for me to do sports activity or exercise',
  'It is hard to pay attention at school',
  'I forget things',
  'I have trouble keeping up with my work or studies',
  'I feel lonely and not interested in my work',
  'I feel I want to eat less to lose my weight',
];

class SedentaryDataTwo {
  Map<SedentaryCategoryTwo, String> choices = {};

  SedentaryDataTwo();

  int get calculatedSedentaryScore {
    int score = 0;
    for (String frequency in choices.values) {
      switch (frequency) {
        case 'Never':
          score += 0;
          break;
        case 'Rarely':
          score += 1;
          break;
        case 'Sometimes':
          score += 2;
          break;
        case 'Often':
          score += 3;
          break;
        case 'Almost Always':
          score += 4;
          break;
      }
    }
    return score;
  }
}

// Sleeping Habits Data
enum SleepingCategory {
  falling,
  wakeUp,
  noise,
  wakeUp2,
  classes,
  headache,
  irritated,
  studies,
  forget,
}

const List<String> sleepingFrequencyOptions = [
  'Never',
  'Rarely',
  'Sometimes',
  'Often',
  'Almost Always',
];

const List<String> sleepingCategoryNames = [
  'I have difficulty falling asleep (cannot get sleep within 30 minutes)',
  'I wake up while sleeping (bad dreams etc.,)',
  'I wake up easily from the noise',
  'I have difficulty getting back to sleep once I wake up in the middle of the night',
  'Sleepiness interferes with my classes',
  'Poor sleep gives me a headache',
  'Poor sleep makes me irritated',
  'Poor sleep makes me lose interest in work/studies',
  'Poor sleep makes me forget things more easily',
];

class SleepingData {
  Map<SleepingCategory, String> choices = {};

  SleepingData();

  int get calculatedSleepingScore {
    int score = 0;
    for (String frequency in choices.values) {
      switch (frequency) {
        case 'Never':
          score += 0;
          break;
        case 'Rarely':
          score += 1;
          break;
        case 'Sometimes':
          score += 2;
          break;
        case 'Often':
          score += 3;
          break;
        case 'Almost Always':
          score += 4;
          break;
      }
    }
    return score;
  }
}
