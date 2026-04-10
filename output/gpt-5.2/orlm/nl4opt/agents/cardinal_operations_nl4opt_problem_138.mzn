% Parameters
% Nutritional content per item
int: protein_per_smoothie = 2;
int: calories_per_smoothie = 300;

int: protein_per_bar = 7;
int: calories_per_bar = 250;

% Dietary constraints
int: max_calories = 2000;

% Relationship constraint: bars are 2x smoothies
int: bar_to_smoothie_ratio = 2;

% Useful bounds (derived)
int: max_smoothies = max_calories div calories_per_smoothie;
int: max_bars = max_calories div calories_per_bar;

% Variables
var 0..max_smoothies: smoothies; % number of smoothies to consume
var 0..max_bars: bars;           % number of protein bars to consume
var 0..(protein_per_smoothie*max_smoothies + protein_per_bar*max_bars): total_protein; % total protein intake

% Constraints
% Link total_protein to decision variables (compute total protein intake)
constraint
  total_protein = protein_per_smoothie * smoothies
                + protein_per_bar * bars;

% Calorie budget constraint (do not exceed maximum allowed calories)
constraint
  calories_per_smoothie * smoothies
+ calories_per_bar * bars
<= max_calories;

% Ratio constraint: must eat bar_to_smoothie_ratio times as many bars as smoothies
constraint
  bars = bar_to_smoothie_ratio * smoothies;

% Objective
solve maximize total_protein;