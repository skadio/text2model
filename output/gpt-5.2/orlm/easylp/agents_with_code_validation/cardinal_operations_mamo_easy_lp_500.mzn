% Parameters
int: max_total_properties = 1000;          % Maximum total number of properties (X + Y)
int: min_weighted_properties = 2000;       % Minimum required: 3*X + 2*Y
int: max_difference = 300;                % Maximum allowed absolute difference |X - Y|

int: cost_residential_k = 200;            % Cost per residential property (in thousand dollars)
int: cost_commercial_k  = 150;            % Cost per commercial property (in thousand dollars)

% Variables
var 0..max_total_properties: X;           % Number of residential properties (integer, nonnegative)
var 0..max_total_properties: Y;           % Number of commercial properties (integer, nonnegative)

var 0..(cost_residential_k*max_total_properties + cost_commercial_k*max_total_properties): total_cost_k;
                                          % Total investment cost (in thousand dollars)

% Constraints
% Total properties limit: X + Y <= max_total_properties
constraint
  X + Y <= max_total_properties;

% Diversification (weighted) requirement: 3*X + 2*Y >= min_weighted_properties
constraint
  3 * X + 2 * Y >= min_weighted_properties;

% Balance requirement: |X - Y| <= max_difference
constraint
  abs(X - Y) <= max_difference;

% Define total cost (in thousand dollars): total_cost_k = 200*X + 150*Y
constraint
  total_cost_k = cost_residential_k * X + cost_commercial_k * Y;

% Objective
solve minimize total_cost_k;

% (Optional) Output for clarity
output [
  "X (residential) = ", show(X), "\n",
  "Y (commercial)  = ", show(Y), "\n",
  "Total cost (thousand $) = ", show(total_cost_k), "\n",
  "Total cost ($) = ", show(total_cost_k * 1000), "\n"
];