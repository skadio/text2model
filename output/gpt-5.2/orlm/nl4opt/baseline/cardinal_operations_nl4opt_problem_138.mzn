% Diet meal prep optimization: maximize protein under calorie limit
% Data embedded directly in the model.

int: protein_smoothie = 2;
int: calories_smoothie = 300;

int: protein_bar = 7;
int: calories_bar = 250;

int: calorie_limit = 2000;

% Decision variables
var 0..100: smoothies;
var 0..100: bars;

% Constraints
constraint bars = 2 * smoothies;
constraint calories_smoothie * smoothies + calories_bar * bars <= calorie_limit;

% Objective: maximize total protein intake
var int: total_protein = protein_smoothie * smoothies + protein_bar * bars;
solve maximize total_protein;

output [
  "smoothies = ", show(smoothies), "\n",
  "protein_bars = ", show(bars), "\n",
  "total_calories = ", show(calories_smoothie * smoothies + calories_bar * bars), "\n",
  "total_protein = ", show(total_protein), "\n"
];