% Parameters
int: ship_capacity = 30;              % Total ship weight capacity (tons)
int: weight_X = 2;                    % Weight per unit of cargo X (tons)
int: weight_Y = 3;                    % Weight per unit of cargo Y (tons)

int: contract_units_X = 4;            % Units of X in the contract weight requirement
int: contract_units_Y = 1;            % Units of Y in the contract weight requirement
int: contract_min_weight = 10;        % Minimum required combined weight for contract (tons)

int: cost_X = 5;                      % Transportation cost per unit of X (dollars)
int: cost_Y = 7;                      % Transportation cost per unit of Y (dollars)

% Variables
var 0..(ship_capacity div weight_X): x_units;  % Units of cargo X (integer, nonnegative)
var 0..(ship_capacity div weight_Y): y_units;  % Units of cargo Y (integer, nonnegative)

var 0..(cost_X*(ship_capacity div weight_X) + cost_Y*(ship_capacity div weight_Y)): total_cost;
% Total transportation cost (dollars)

% Constraints

% --- Ship capacity constraint (total shipped weight must not exceed capacity) ---
constraint
  weight_X * x_units + weight_Y * y_units <= ship_capacity;

% --- Contract requirement constraint ---
% Must ship at least the stated contract quantities (indivisible integer cargo).
constraint x_units >= contract_units_X;
constraint y_units >= contract_units_Y;

% The contract's combined weight requirement (redundant given weights, but included for clarity).
constraint
  contract_units_X * weight_X + contract_units_Y * weight_Y >= contract_min_weight;

% --- Total cost definition (link decision variables to total_cost) ---
constraint
  total_cost = cost_X * x_units + cost_Y * y_units;

% Objective
solve minimize total_cost;