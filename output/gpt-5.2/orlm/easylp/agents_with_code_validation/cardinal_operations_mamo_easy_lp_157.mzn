% Parameters
int: max_total_properties = 1000;         % Maximum total number of properties that can be purchased
int: cost_X = 300000;                    % Cost per type X property (in dollars)
int: cost_Y = 200000;                    % Cost per type Y property (in dollars)
int: diversity_multiplier = 3;           % Requires X >= 3 * Y

% Variables
var 0..max_total_properties: num_X;      % Number of type X properties purchased (integer, nonnegative)
var 0..max_total_properties: num_Y;      % Number of type Y properties purchased (integer, nonnegative)
var 0..(cost_X * max_total_properties + cost_Y * max_total_properties): total_cost; % Total cost (in dollars)

% Constraints
% Total properties limit (financial constraint)
constraint
  num_X + num_Y <= max_total_properties;

% Diversity constraint: ensure enough type X relative to type Y
constraint
  num_X >= diversity_multiplier * num_Y;

% Total cost definition (linking decision variables to cost)
constraint
  total_cost = cost_X * num_X + cost_Y * num_Y;

% Objective
solve minimize total_cost;