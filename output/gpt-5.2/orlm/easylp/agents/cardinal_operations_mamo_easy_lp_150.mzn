% Parameters
int: capacity_tons = 30;                % Total ship weight capacity (tons)
int: weight_X_tons = 2;                 % Weight per unit of cargo X (tons/unit)
int: weight_Y_tons = 3;                 % Weight per unit of cargo Y (tons/unit)

int: contract_X_units = 4;              % Units of X used in the contract combination
int: contract_Y_units = 1;              % Units of Y used in the contract combination
int: contract_min_tons = 10;            % Minimum required weight (tons) for the contract combination

int: cost_X_dollars = 5;                % Transport cost per unit of X ($/unit)
int: cost_Y_dollars = 7;                % Transport cost per unit of Y ($/unit)

% Helper bounds (integer upper bounds from capacity)
int: max_X_units = capacity_tons div weight_X_tons;  % Maximum possible X units by capacity
int: max_Y_units = capacity_tons div weight_Y_tons;  % Maximum possible Y units by capacity


% Variables
var 0..max_X_units: x_units;            % Number of units of cargo X (integer, nonnegative)
var 0..max_Y_units: y_units;            % Number of units of cargo Y (integer, nonnegative)

var 0..(cost_X_dollars*max_X_units + cost_Y_dollars*max_Y_units): total_cost; % Total transportation cost ($)


% Constraints
% Capacity constraint: total shipped weight must not exceed ship capacity
constraint
  weight_X_tons * x_units + weight_Y_tons * y_units <= capacity_tons;

% Contract constraint: specified combination (4 units of X and 1 unit of Y) must weigh at least 10 tons
% Note: This is a feasibility check on the contract specification itself (constant expression).
constraint
  contract_X_units * weight_X_tons + contract_Y_units * weight_Y_tons >= contract_min_tons;

% Total cost definition: link total_cost to the chosen number of units
constraint
  total_cost = cost_X_dollars * x_units + cost_Y_dollars * y_units;


% Objective
solve minimize total_cost;