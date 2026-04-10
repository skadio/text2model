% Parameters
int: max_resources = 100;                 % Upper bound on total available resources
int: eff_req = 350;                       % Minimum required combined effectiveness

int: eff_X = 5;                           % Effectiveness per unit for Operation X
int: eff_Y = 3;                           % Effectiveness per unit for Operation Y
int: eff_Z = 7;                           % Effectiveness per unit for Operation Z

int: cost_X = 5000;                       % Cost per unit for Operation X (dollars)
int: cost_Y = 4000;                       % Cost per unit for Operation Y (dollars)
int: cost_Z = 6000;                       % Cost per unit for Operation Z (dollars)

% Variables
var 0..max_resources: x;                  % Integer units allocated to Operation X
var 0..max_resources: y;                  % Integer units allocated to Operation Y
var 0..max_resources: z;                  % Integer units allocated to Operation Z

var 0..max_resources: total_resources;          % Total allocated resources
var 0..(eff_Z * max_resources): effectiveness;  % Combined effectiveness (bounded)
var 0..(cost_Z * max_resources): total_cost;    % Total cost (bounded)

% Constraints
% Resource accounting: define total allocated resources
constraint
  total_resources = x + y + z;

% Resource limit: cannot exceed available resources
constraint
  total_resources <= max_resources;

% Effectiveness accounting: define combined effectiveness
constraint
  effectiveness = eff_X * x + eff_Y * y + eff_Z * z;

% Minimum effectiveness requirement
constraint
  effectiveness >= eff_req;

% Strategy requirement: twice X and Y subtracted from Z should be non-negative
constraint
  z - 2 * x - 2 * y >= 0;

% Cost accounting: define total cost
constraint
  total_cost = cost_X * x + cost_Y * y + cost_Z * z;

% Objective
solve minimize total_cost;