% Parameters
% Nutrition per item
int: protein_per_smoothie = 2;
int: calories_per_smoothie = 300;

int: protein_per_bar = 7;
int: calories_per_bar = 250;

% Diet rule and calorie limit
int: bar_to_smoothie_ratio = 2;     % bars = 2 * smoothies
int: max_calories = 2000;

% Variables
var 0..(max_calories div calories_per_smoothie): smoothies;  % number of smoothies
var 0..(max_calories div calories_per_bar): bars;            % number of protein bars

% Total protein intake (bounded for linear safety)
var 0..(protein_per_smoothie*(max_calories div calories_per_smoothie)
      + protein_per_bar*(max_calories div calories_per_bar)): total_protein;

% Constraints
% Link total protein to chosen quantities
constraint
  total_protein = protein_per_smoothie * smoothies
                + protein_per_bar * bars;

% Enforce diet rule: must eat 2 times more protein bars than smoothies
constraint
  bars = bar_to_smoothie_ratio * smoothies;

% Calorie intake must not exceed the maximum allowed calories
constraint
  calories_per_smoothie * smoothies
+ calories_per_bar * bars
<= max_calories;

% Objective
solve maximize total_protein;