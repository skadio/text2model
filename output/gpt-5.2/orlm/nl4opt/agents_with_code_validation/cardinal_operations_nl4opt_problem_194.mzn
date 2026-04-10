% Parameters
int: protein_fish   = 10;   % protein units per fish meal
int: iron_fish      = 12;   % iron units per fish meal
int: fat_fish       = 7;    % fat units per fish meal

int: protein_chicken = 15;  % protein units per chicken meal
int: iron_chicken    = 8;   % iron units per chicken meal
int: fat_chicken     = 10;  % fat units per chicken meal

int: min_protein = 130;     % minimum required protein
int: min_iron    = 120;     % minimum required iron

int: chicken_to_fish_ratio = 2; % at least this many chicken meals per fish meal

% Upper bounds derived from requirements (safe, tight enough for bounded vars)
int: max_fish    = (max(min_protein div protein_fish, min_iron div iron_fish)) + 20;
int: max_chicken = (max(min_protein div protein_chicken, min_iron div iron_chicken)) + 20;

% Variables
var 0..max_fish: fish_meals;          % number of fish meals
var 0..max_chicken: chicken_meals;    % number of chicken meals
var 0..(fat_fish*max_fish + fat_chicken*max_chicken): total_fat; % total fat intake

% Constraints

% Nutritional requirements: meet minimum protein intake
constraint
  protein_fish * fish_meals + protein_chicken * chicken_meals >= min_protein;

% Nutritional requirements: meet minimum iron intake
constraint
  iron_fish * fish_meals + iron_chicken * chicken_meals >= min_iron;

% Preference constraint: at least chicken_to_fish_ratio times as many chicken meals as fish meals
constraint
  chicken_meals >= chicken_to_fish_ratio * fish_meals;

% Definition constraint: compute total fat intake from chosen meals
constraint
  total_fat = fat_fish * fish_meals + fat_chicken * chicken_meals;

% Objective
solve minimize total_fat;