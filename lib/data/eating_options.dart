import 'package:pedia_predict/models/eating_model.dart';

const List<String> frequencyOptions = [
  'Never',
  'Rarely',
  'Sometimes',
  'Often',
  'Almost Always',
];

const Map<Category, List<String>> eatingOptions = {
  Category.cereals: [
    'Bread/Toast',
    'Chapati',
    'Paratha',
    'Puri',
    'Roti, Rice, Ragi etc',
    'Ragi Ball',
    'Pasta',
    'Rice',
    'Idli',
    'Dosa',
    'Spaghetti/Vermicelli',
    'Rava Upma/Kesari Bath',
    'Puffed rice',
    'Porridge',
    'Kichdi',
  ],
  Category.pulsesAndLegumes: [
    'Pulse dish e.g. lentils, green gram pulse',
    'Legume dish e.g. red kidney beans',
  ],
  Category.vegetables: [
    'Green leafy vegetable dish',
    'Raw vegetables or Other vegetable dishes e.g. stuffed bitter gourd, pumpkin curry, vegetable korma, sambar, curry, etc.',
  ],
  Category.fruits: [
    'Apple',
    'Sweet lime',
    'Grapes',
    'Sapota',
    'Banana',
    'Pomegranate',
    'Pineapple',
    'Guava',
    'Papaya',
    'Orange',
    'Other',
    'Fruit Juice (Fresh) (200 ml)',
  ],
  Category.milkAndMilkProducts: [
    'Coffee/ Tea ',
    'Milk/ Complan/ Boost etc.,',
    'Lassi / Curd/ Buttermilk etc.,',
    'paneer dish e.g. paneer butter masala (cottage cheese cooked in cream sauce) etc.,',
    'Ghee/ Butter',
    'Cheese',
  ],
  Category.nonVegetarian: [
    'Egg (1 boiled egg/ 1 omelet)/ egg dish',
    'Chicken dish e.g. chilli chicken, Chicken fried rice, kebab, etc.,',
    'Fish dish e.g. fish fry',
    'Beef dish',
    'Red meat dish e.g. mutton curry',
    'Prawn dish',
  ],
  Category.snacks: [
    'Biscuits/cookies',
    'Bajji, Pakora, Bonda',
    'French fries / Potato chips',
    'Pav bhaji',
    'Samosa/ Kachori/ Puffs (veg/ egg/ chicken)',
    'Pizza',
    'Sandwich',
    'Burger',
    'Gobi Manchurian/ Paneer Manchurian etc.,',
    'Pani puri/ Masala puri etc.,',
    'Vegetable roll/wrap',
    'Chicken roll/wrap/nuggets',
    'Egg roll',
    'Momos ',
    'Indian savoury e.g. Mixtures, Bhujias etc.,',
    'Popcorn',
    'Churmuri',
    'Noodles',
  ],
  Category.sweets: [
    'Ice cream/ Ice candy',
    'Sugar candy',
    'Chocolates',
    'Custard',
    'Jelly',
    'Cake/pastries',
    'Mysurupak/besan laddoo/any other sweets',
    'Homemade sweets',
  ],
  Category.beverages: [
    'Soft drinks e.g. Sprite, Coke, Pepsi',
    'Energy drink (Tang, Pediasure, glucon D etc.,)',
    'Hot chocolate',
  ],
  Category.others: [
    'Food 1',
    'Food 2',
    'Food 3',
  ],
};
