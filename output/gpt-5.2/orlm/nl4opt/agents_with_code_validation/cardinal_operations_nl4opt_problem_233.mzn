% Parameters
int: min_calcium = 15;        % Minimum required calcium units
int: min_vitamins = 20;       % Minimum required vitamin mix units
int: min_protein = 20;        % Minimum required protein units

int: cost_regular = 20;       % Cost per bag of regular brand
int: cost_premium = 35;       % Cost per bag of premium brand

int: calcium_regular = 4;     % Calcium units per regular bag
int: vitamins_regular = 7;    % Vitamin mix units per regular bag
int: protein_regular = 10;    % Protein units per regular bag

int: calcium_premium = 12;    % Calcium units per premium bag
int: vitamins_premium = 10;   % Vitamin mix units per premium bag
int: protein_premium = 16;    % Protein units per premium bag

% Variables
var 0..100: bags_regular;     % Number of regular bags to use
var 0..100: bags_premium;     % Number of premium bags to use
var 0..10000: total_cost;     % Total cost to minimize

% Constraints
% Compute total cost from chosen number of bags
constraint
  total_cost = cost_regular * bags_regular + cost_premium * bags_premium;

% Meet minimum nutrient requirements
constraint
  calcium_regular * bags_regular + calcium_premium * bags_premium >= min_calcium;

constraint
  vitamins_regular * bags_regular + vitamins_premium * bags_premium >= min_vitamins;

constraint
  protein_regular * bags_regular + protein_premium * bags_premium >= min_protein;

% Objective
solve minimize total_cost;