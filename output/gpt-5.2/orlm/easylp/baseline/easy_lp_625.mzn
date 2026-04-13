% Supply chain resource allocation MILP (all data embedded)

% Decision variables (whole numbers)
var 0..10000: raw;          % raw materials
var 0..10000: labour;       % labour hours
var 0..10000: prod;         % production costs units
var 0..10000: trans;        % transportation costs units

% Constraints
constraint raw + labour >= 500;
constraint prod <= raw div 2 + 1000;            % "cannot exceed half the quantity of raw materials by more than 1000"
constraint trans >= labour + 200;               % transportation exceeds labour by at least 200
constraint raw + prod - labour = 0;             % balance requirement

% Objective: minimize total cost.
% Use scaled integers to represent costs: 2, 3, 1.5, 4 -> multiply by 2 => 4, 6, 3, 8
var int: total_cost_scaled = 4*raw + 6*labour + 3*prod + 8*trans;
solve minimize total_cost_scaled;

% Rounded to nearest whole number in original units:
% original cost = total_cost_scaled / 2
% rounded = floor(original + 0.5) = (total_cost_scaled + 1) div 2
output [
  "raw=", show(raw), "\n",
  "labour=", show(labour), "\n",
  "prod=", show(prod), "\n",
  "trans=", show(trans), "\n",
  "min_total_cost_rounded=", show((total_cost_scaled + 1) div 2), "\n"
];