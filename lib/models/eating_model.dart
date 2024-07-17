enum Category {
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

const List<String> categoryNames = [
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

class EatingModel {
  Map<Category, Map<int, String>> choices = {};

  Set<Category> get categoriesWithTextInput => {Category.others};

  EatingModel();

  int get calculatedEatingScore {
    int score = 0;
    for (var categoryChoices in choices.values) {
      for (String frequency in categoryChoices.values) {
        // Assign scores based on frequency, e.g., Almost Always = 5, Often = 4, etc.
        switch (frequency) {
          case 'Almost Always':
            score += 40;
            break;
          case 'Often':
            score += 30;
            break;
          case 'Sometimes':
            score += 20;
            break;
          case 'Rarely':
            score += 10;
            break;
          case 'Never':
            score += 0;
            break;
        }
      }
    }
    return score;
  }
}
