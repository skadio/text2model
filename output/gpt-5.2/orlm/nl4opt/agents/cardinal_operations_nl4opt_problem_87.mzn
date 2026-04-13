% Parameters
float: cost_noodles = 5.0;            % dollars per serving of noodles
float: calories_noodles = 600.0;      % calories per serving of noodles
float: protein_noodles = 1.5;         % grams protein per serving of noodles

float: cost_bar = 2.5;               % dollars per serving of protein bar
float: calories_bar = 250.0;         % calories per serving of protein bar
float: protein_bar = 5.0;            % grams protein per serving of protein bar

float: min_calories = 2000.0;        % minimum daily calories
float: min_protein = 16.0;           % minimum daily protein (grams)

% Variables
var 0.0..1.0e6: x_noodles;           % number of servings of noodles (continuous, nonnegative)
var 0.0..1.0e6: x_bar;               % number of servings of protein bars (continuous, nonnegative)

var 0.0..1.0e12: total_cost;         % total daily cost
var 0.0..1.0e12: total_calories;     % total daily calories
var 0.0..1.0e12: total_protein;      % total daily protein (grams)

% Constraints
% Link total daily cost to chosen servings
constraint
  total_cost = cost_noodles * x_noodles + cost_bar * x_bar;

% Link total daily calories to chosen servings
constraint
  total_calories = calories_noodles * x_noodles + calories_bar * x_bar;

% Link total daily protein to chosen servings
constraint
  total_protein = protein_noodles * x_noodles + protein_bar * x_bar;

% Nutrition requirements: meet or exceed minimums
constraint
  total_calories >= min_calories;

constraint
  total_protein >= min_protein;

% Objective
solve minimize total_cost;