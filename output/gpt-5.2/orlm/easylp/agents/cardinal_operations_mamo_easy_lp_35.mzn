% Parameters
int: min_total_exposure = 50000;      % Minimum required exposure: 2*stocks + bonds >= 50000
int: max_imbalance = 20000;           % Maximum allowed imbalance: stocks - 2*bonds <= 20000
int: cost_stock = 4;                  % Cost per unit of stocks
int: cost_bond  = 3;                  % Cost per unit of bonds

% Variables
var 0..50000: stocks;                 % Whole-number units invested in stocks
var 0..50000: bonds;                  % Whole-number units invested in bonds
var 0..(cost_stock*50000 + cost_bond*50000): total_cost; % Total investment cost (bounded)

% Constraints
% Exposure constraint: ensure sufficient combined exposure (risk/return requirement)
constraint
  2 * stocks + bonds >= min_total_exposure;

% Imbalance constraint: keep portfolio balanced (stocks not too high vs bonds)
constraint
  stocks - 2 * bonds <= max_imbalance;

% Total cost definition: compute total cost from chosen units
constraint
  total_cost = cost_stock * stocks + cost_bond * bonds;

% Objective
solve minimize total_cost;