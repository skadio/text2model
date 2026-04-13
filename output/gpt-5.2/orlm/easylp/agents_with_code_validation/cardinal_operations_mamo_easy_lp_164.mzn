% Parameters
% Investment cost per property (in dollars)
int: cost_commercial = 150000;
int: cost_residential = 200000;

% Maximum total number of properties
int: max_properties = 10;

% Diversification requirement: X + 0.5*Y >= 5
% Scaled to avoid fractions: 2*X + Y >= 10
int: diversification_rhs = 10;

% Variables
% Number of commercial buildings (whole units)
var 0..max_properties: x_commercial;

% Number of residential complexes (whole units)
var 0..max_properties: y_residential;

% Total investment (in dollars), bounded by max_properties * max unit cost
var 0..(max_properties * max(cost_commercial, cost_residential)): total_investment;

% Constraints
% Budgeted total number of properties cannot exceed the maximum allowed
constraint
  x_commercial + y_residential <= max_properties;

% Diversification requirement (scaled to avoid fractions): 2*X + Y >= 10
constraint
  2 * x_commercial + y_residential >= diversification_rhs;

% Define total investment as the sum of investments in each property type
constraint
  total_investment = cost_commercial * x_commercial + cost_residential * y_residential;

% Objective
solve minimize total_investment;