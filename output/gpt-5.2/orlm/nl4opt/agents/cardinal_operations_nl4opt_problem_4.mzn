% Parameters
% Minimum required nutrients in the final mixture
int: min_protein = 30;
int: min_fat = 50;

% Cost per kilogram of each feed
int: cost_A = 100;
int: cost_B = 80;

% Nutrient content per kilogram of each feed
int: protein_A = 10;
int: fat_A = 8;

int: protein_B = 7;
int: fat_B = 15;

% Variables
% Kilograms of each feed to include in the mixture (non-negative)
var 0.0..1000.0: kg_A;   % amount of Feed A (kg)
var 0.0..1000.0: kg_B;   % amount of Feed B (kg)

% Total cost of the mixture (objective-related variable)
var 0.0..1000000.0: total_cost;  % total cost ($)

% Constraints
% --- Nutrient minimum requirements ---
% Ensure the mixture meets the minimum protein requirement
constraint
  protein_A * kg_A + protein_B * kg_B >= min_protein;

% Ensure the mixture meets the minimum fat requirement
constraint
  fat_A * kg_A + fat_B * kg_B >= min_fat;

% --- Total cost definition ---
% Link total_cost to the chosen quantities and per-kg costs
constraint
  total_cost = cost_A * kg_A + cost_B * kg_B;

% Objective
solve minimize total_cost;