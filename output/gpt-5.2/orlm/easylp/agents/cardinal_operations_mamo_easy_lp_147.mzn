% Parameters
int: support_X = 50;                 % Support points required per unit of X
int: support_Y = 75;                 % Support points required per unit of Y

int: min_mission_strength = 60;      % Minimum required mission strength
int: max_logistics_capacity = 120;   % Maximum allowed logistics capacity

int: coeff_strength_X = 2;           % Coefficient of X in mission strength constraint
int: coeff_strength_Y = 1;           % Coefficient of Y in mission strength constraint

int: coeff_capacity_X = 1;           % Coefficient of X in logistics capacity constraint
int: coeff_capacity_Y = 3;           % Coefficient of Y in logistics capacity constraint


% Variables
var 0..max_logistics_capacity: units_X;  % Number of units of X (integer, nonnegative)
var 0..max_logistics_capacity: units_Y;  % Number of units of Y (integer, nonnegative)

var 0..(support_X * max_logistics_capacity + support_Y * max_logistics_capacity): total_support;
% Total support points allocated (objective-related)


% Constraints
% Link total_support to the chosen numbers of units (support points accounting)
constraint
  total_support = support_X * units_X + support_Y * units_Y;

% Mission strength requirement: ensure the mission is strong enough
constraint
  coeff_strength_X * units_X + coeff_strength_Y * units_Y >= min_mission_strength;

% Logistics capacity limit: do not exceed available logistical capacity
constraint
  coeff_capacity_X * units_X + coeff_capacity_Y * units_Y <= max_logistics_capacity;


% Objective
solve minimize total_support;