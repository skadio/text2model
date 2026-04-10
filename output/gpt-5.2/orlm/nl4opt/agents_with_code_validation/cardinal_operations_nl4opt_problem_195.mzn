% Parameters
% Nutrient content per pill and daily minimum requirements (embedded data)
int: iron_per_A = 5;
int: calcium_per_A = 10;
int: iron_per_B = 4;
int: calcium_per_B = 15;

int: min_iron = 40;
int: min_calcium = 50;

int: cost_A = 2;
int: cost_B = 3;

% Upper bounds for decision variables (safe bounds derived from requirements)
% A alone for iron: ceil(40/5)=8, for calcium: ceil(50/10)=5 => max 8
% B alone for iron: ceil(40/4)=10, for calcium: ceil(50/15)=4 => max 10
int: max_A = 8;
int: max_B = 10;

% Variables
var 0..max_A: pills_A; % number of supplement A pills to buy
var 0..max_B: pills_B; % number of supplement B pills to buy

% Constraints
% Nutritional requirements: meet or exceed minimum daily iron intake
constraint
  iron_per_A * pills_A + iron_per_B * pills_B >= min_iron;

% Nutritional requirements: meet or exceed minimum daily calcium intake
constraint
  calcium_per_A * pills_A + calcium_per_B * pills_B >= min_calcium;

% Objective
solve minimize cost_A * pills_A + cost_B * pills_B;