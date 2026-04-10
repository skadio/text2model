% Parameters
% Nutrient minimum requirements
int: minCalcium  = 15;
int: minVitamin  = 20;
int: minProtein  = 20;

% Regular brand: cost and nutrient contents per bag
int: costRegular     = 20;
int: calciumRegular  = 4;
int: vitaminRegular  = 7;
int: proteinRegular  = 10;

% Premium brand: cost and nutrient contents per bag
int: costPremium     = 35;
int: calciumPremium  = 12;
int: vitaminPremium  = 10;
int: proteinPremium  = 16;

% Simple safe upper bounds on bags (from meeting each minimum with each brand alone)
% Regular-only bounds
int: ubRegCalcium = (minCalcium + calciumRegular - 1) div calciumRegular;
int: ubRegVitamin = (minVitamin + vitaminRegular - 1) div vitaminRegular;
int: ubRegProtein = (minProtein + proteinRegular - 1) div proteinRegular;
int: ubRegular    = max(ubRegCalcium, max(ubRegVitamin, ubRegProtein));

% Premium-only bounds
int: ubPreCalcium = (minCalcium + calciumPremium - 1) div calciumPremium;
int: ubPreVitamin = (minVitamin + vitaminPremium - 1) div vitaminPremium;
int: ubPreProtein = (minProtein + proteinPremium - 1) div proteinPremium;
int: ubPremium    = max(ubPreCalcium, max(ubPreVitamin, ubPreProtein));

% Variables
% Number of bags of each brand to mix (nonnegative integers)
var 0..ubRegular: bagsRegular;
var 0..ubPremium: bagsPremium;

% Total cost to minimize
var 0..(costRegular * ubRegular + costPremium * ubPremium): totalCost;

% Constraints
% --- Nutrient requirement constraints (meet or exceed minimums) ---
constraint
  calciumRegular * bagsRegular + calciumPremium * bagsPremium >= minCalcium;

constraint
  vitaminRegular * bagsRegular + vitaminPremium * bagsPremium >= minVitamin;

constraint
  proteinRegular * bagsRegular + proteinPremium * bagsPremium >= minProtein;

% --- Cost aggregation constraint (define total cost) ---
constraint
  totalCost = costRegular * bagsRegular + costPremium * bagsPremium;

% Objective
solve minimize totalCost;