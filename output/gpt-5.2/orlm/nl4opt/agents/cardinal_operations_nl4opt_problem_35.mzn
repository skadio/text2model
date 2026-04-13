% Parameters
int: calories_per_almonds_serving = 200;
int: protein_per_almonds_serving  = 20;
int: fat_per_almonds_serving      = 15;

int: calories_per_cashews_serving = 300;
int: protein_per_cashews_serving  = 25;
int: fat_per_cashews_serving      = 12;

int: min_weekly_calories = 10000;
int: min_weekly_protein  = 800;

% Variables
% Number of servings (non-negative integers)
var 0..100000: almonds_servings;  % servings of almonds to eat this week
var 0..100000: cashews_servings;  % servings of cashews to eat this week

% Total fat intake (to be minimized)
var 0..2000000: total_fat;        % total grams of fat consumed this week

% Constraints
% Link total_fat to servings and per-serving fat amounts
constraint
  total_fat =
    fat_per_almonds_serving * almonds_servings +
    fat_per_cashews_serving * cashews_servings;

% Minimum weekly calorie requirement
constraint
  calories_per_almonds_serving * almonds_servings +
  calories_per_cashews_serving * cashews_servings
  >= min_weekly_calories;

% Minimum weekly protein requirement
constraint
  protein_per_almonds_serving * almonds_servings +
  protein_per_cashews_serving * cashews_servings
  >= min_weekly_protein;

% Must eat at least twice as many servings of almonds as cashews
constraint
  almonds_servings >= 2 * cashews_servings;

% Objective
solve minimize total_fat;