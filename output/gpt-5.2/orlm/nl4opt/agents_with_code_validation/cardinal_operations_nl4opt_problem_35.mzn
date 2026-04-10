% Parameters
% Nutrition per serving
int: calories_almonds = 200;
int: protein_almonds  = 20;
int: fat_almonds      = 15;

int: calories_cashews = 300;
int: protein_cashews  = 25;
int: fat_cashews      = 12;

% Weekly minimum requirements
int: min_calories = 10000;
int: min_protein  = 800;

% Policy: almonds servings >= 2 * cashews servings
int: almonds_to_cashews_ratio = 2;

% Upper bounds derived from meeting minimums with the most efficient single food
% (used to keep variables bounded)
int: max_almonds = min(
  max(min_calories div calories_almonds + 1,
      min_protein  div protein_almonds  + 1),
  1000000
);
int: max_cashews = min(
  max(min_calories div calories_cashews + 1,
      min_protein  div protein_cashews  + 1),
  1000000
);

% Variables
var 0..max_almonds: servings_almonds; % number of almond servings
var 0..max_cashews: servings_cashews; % number of cashew servings

var 0..(fat_almonds * max_almonds + fat_cashews * max_cashews): total_fat; % total fat intake


% Constraints

% Link total fat variable to decision variables
constraint
  total_fat = fat_almonds * servings_almonds + fat_cashews * servings_cashews;

% Meet weekly minimum calorie requirement
constraint
  calories_almonds * servings_almonds + calories_cashews * servings_cashews
  >= min_calories;

% Meet weekly minimum protein requirement
constraint
  protein_almonds * servings_almonds + protein_cashews * servings_cashews
  >= min_protein;

% Policy constraint: at least a given ratio of almonds to cashews
constraint
  servings_almonds >= almonds_to_cashews_ratio * servings_cashews;


% Objective
solve minimize total_fat;