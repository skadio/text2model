% Parameters
int: total_funding = 100;              % Total funding available
int: min_funding_X = 30;               % Minimum required for department X
int: min_funding_Y = 20;               % Minimum required for department Y
int: min_funding_Z = 10;               % Minimum required for department Z

int: cost_per_unit_X = 20;             % Cost per unit effectiveness for X
int: cost_per_unit_Y = 15;             % Cost per unit effectiveness for Y
int: cost_per_unit_Z = 10;             % Cost per unit effectiveness for Z


% Variables
var 0..total_funding: funding_X;       % Funding allocated to department X (integer units)
var 0..total_funding: funding_Y;       % Funding allocated to department Y (integer units)
var 0..total_funding: funding_Z;       % Funding allocated to department Z (integer units)

var 0..(total_funding * max([cost_per_unit_X, cost_per_unit_Y, cost_per_unit_Z])): total_cost;
                                      % Total cost (bounded linear expression)


% Constraints
% Department minimum funding requirements
constraint funding_X >= min_funding_X;
constraint funding_Y >= min_funding_Y;
constraint funding_Z >= min_funding_Z;

% Total available funding limit (budget constraint)
constraint funding_X + funding_Y + funding_Z <= total_funding;

% Total cost definition (linear cost aggregation)
constraint total_cost =
  cost_per_unit_X * funding_X +
  cost_per_unit_Y * funding_Y +
  cost_per_unit_Z * funding_Z;


% Objective
solve minimize total_cost;