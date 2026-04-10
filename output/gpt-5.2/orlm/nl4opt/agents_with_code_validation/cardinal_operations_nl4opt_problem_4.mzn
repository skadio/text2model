% Parameters
% Nutritional requirements (minimum units)
int: min_protein = 30;                 % minimum required protein units
int: min_fat = 50;                     % minimum required fat units

% Feed costs ($ per kg)
int: cost_A = 100;                     % $ per kg of Feed A
int: cost_B = 80;                      % $ per kg of Feed B

% Nutritional content (units per kg)
int: protein_A = 10;                   % protein units per kg of Feed A
int: fat_A = 8;                        % fat units per kg of Feed A
int: protein_B = 7;                    % protein units per kg of Feed B
int: fat_B = 15;                       % fat units per kg of Feed B


% Variables
% Decision variables: kilograms of each feed to use
var 0..1000: kg_A;                     % kilograms of Feed A in the mix (non-negative)
var 0..1000: kg_B;                     % kilograms of Feed B in the mix (non-negative)

% Derived totals
var 0..200000: total_cost;             % total cost of the mixture
var 0..200000: total_protein;          % total protein in the mixture
var 0..200000: total_fat;              % total fat in the mixture


% Constraints
% Compute totals from chosen kilograms of each feed
constraint
  total_cost = cost_A * kg_A + cost_B * kg_B;

constraint
  total_protein = protein_A * kg_A + protein_B * kg_B;

constraint
  total_fat = fat_A * kg_A + fat_B * kg_B;

% Meet minimum nutritional requirements
constraint
  total_protein >= min_protein;

constraint
  total_fat >= min_fat;


% Objective
solve minimize total_cost;