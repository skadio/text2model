% Parameters
% Nutritional content per serving
int: fat_apple    = 2;
int: folate_apple = 5;
int: fat_carrot   = 4;
int: folate_carrot = 3;

% Preference/ratio requirement: apple servings must be ratio_apple_to_carrot times carrot servings
int: ratio_apple_to_carrot = 3;

% Minimum carrot servings
int: min_carrot_servings = 2;

% Maximum total folate allowed
int: max_folate = 100;

% Useful upper bounds (derived from max_folate and per-serving folate)
int: max_apple_servings  = max_folate div folate_apple;   % 20
int: max_carrot_servings = max_folate div folate_carrot;  % 33


% Variables
var 0..max_apple_servings: apple_servings;        % number of apple servings
var 0..max_carrot_servings: carrot_servings;      % number of carrot servings

% Total fat intake (upper bound based on variable upper bounds)
var 0..(fat_apple * max_apple_servings + fat_carrot * max_carrot_servings): total_fat;


% Constraints
% Link total_fat to servings chosen
constraint
  total_fat = fat_apple * apple_servings + fat_carrot * carrot_servings;

% Enforce preference ratio: apple servings must be exactly 3 times carrot servings
constraint
  apple_servings = ratio_apple_to_carrot * carrot_servings;

% Minimum required carrot servings
constraint
  carrot_servings >= min_carrot_servings;

% Folate consumption must not exceed maximum allowed
constraint
  folate_apple * apple_servings + folate_carrot * carrot_servings <= max_folate;


% Objective
solve maximize total_fat;