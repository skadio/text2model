% Parameters
% Nutrients per serving
int: fat_per_apple    = 2;
int: folate_per_apple = 5;
int: fat_per_carrot   = 4;
int: folate_per_carrot = 3;

% Preference/ratio requirement: apple_servings = apple_to_carrot_ratio * carrot_servings
int: apple_to_carrot_ratio = 3;

% Minimum carrot servings
int: min_carrot_servings = 2;

% Maximum total folate intake
int: max_folate = 100;

% Useful upper bounds derived from max_folate (safe integer bounds)
int: max_apple_servings  = max_folate div folate_per_apple;   % if only apple
int: max_carrot_servings = max_folate div folate_per_carrot;  % if only carrot


% Variables
var 0..max_apple_servings: apple_servings;        % number of apple-flavor servings
var 0..max_carrot_servings: carrot_servings;      % number of carrot-flavor servings

var 0..(fat_per_apple*max_apple_servings + fat_per_carrot*max_carrot_servings): total_fat; % total fat intake
var 0..max_folate: total_folate;                  % total folate consumed


% Constraints
% --- Serving ratio / preference constraint ---
% Baby must eat exactly three times as many apple servings as carrot servings
constraint apple_servings = apple_to_carrot_ratio * carrot_servings;

% --- Minimum carrot consumption constraint ---
constraint carrot_servings >= min_carrot_servings;

% --- Nutrient accounting constraints ---
constraint total_folate = folate_per_apple * apple_servings
                        + folate_per_carrot * carrot_servings;

constraint total_fat = fat_per_apple * apple_servings
                     + fat_per_carrot * carrot_servings;

% --- Folate limit constraint ---
constraint total_folate <= max_folate;


% Objective
solve maximize total_fat;

% (Optional) Output for convenience
output [
  "apple_servings=", show(apple_servings), "\n",
  "carrot_servings=", show(carrot_servings), "\n",
  "total_folate=", show(total_folate), "\n",
  "total_fat=", show(total_fat), "\n"
];