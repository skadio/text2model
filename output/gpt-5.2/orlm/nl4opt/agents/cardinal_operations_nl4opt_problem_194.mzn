% Parameters
int: protein_per_fish    = 10;   % protein units in one fish meal
int: iron_per_fish       = 12;   % iron units in one fish meal
int: fat_per_fish        = 7;    % fat units in one fish meal

int: protein_per_chicken = 15;   % protein units in one chicken meal
int: iron_per_chicken    = 8;    % iron units in one chicken meal
int: fat_per_chicken     = 10;   % fat units in one chicken meal

int: min_protein = 130;          % minimum required protein units
int: min_iron    = 120;          % minimum required iron units

int: chicken_to_fish_ratio = 2;  % chicken meals must be at least this multiple of fish meals

% Variables
var 0..1000: fish_meals;         % number of fish meals (nonnegative integer)
var 0..1000: chicken_meals;      % number of chicken meals (nonnegative integer)

var 0..(fat_per_fish*1000 + fat_per_chicken*1000): total_fat; % total fat intake to minimize

% Constraints
% Nutritional requirement: meet minimum protein intake
constraint
  protein_per_fish * fish_meals + protein_per_chicken * chicken_meals >= min_protein;

% Nutritional requirement: meet minimum iron intake
constraint
  iron_per_fish * fish_meals + iron_per_chicken * chicken_meals >= min_iron;

% Preference constraint: chicken meals must be at least a multiple of fish meals
constraint
  chicken_meals >= chicken_to_fish_ratio * fish_meals;

% Total fat accounting: define total_fat as fat from fish and chicken meals
constraint
  total_fat = fat_per_fish * fish_meals + fat_per_chicken * chicken_meals;

% Objective
solve minimize total_fat;