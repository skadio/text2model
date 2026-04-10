% Parameters
int: max_acres = 1000;              % Maximum total acres available
int: fertility_min = 800;           % Minimum required for soil fertility constraint
int: degradation_max = 500;         % Maximum allowed for soil degradation constraint

int: wheat_cost = 4;                % Cost per acre of wheat
int: corn_cost = 3;                 % Cost per acre of corn


% Variables
var 0..max_acres: wheat_acres;      % Acres planted with wheat (integer, non-negative)
var 0..max_acres: corn_acres;       % Acres planted with corn (integer, non-negative)


% Constraints
% Total land availability: wheat + corn cannot exceed available acres
constraint
  wheat_acres + corn_acres <= max_acres;

% Soil fertility requirement: 2*wheat + 4*corn must be at least the minimum threshold
constraint
  2 * wheat_acres + 4 * corn_acres >= fertility_min;

% Soil degradation limit: 3*wheat - corn must not exceed the maximum allowed difference
constraint
  3 * wheat_acres - corn_acres <= degradation_max;


% Objective
solve minimize wheat_cost * wheat_acres + corn_cost * corn_acres;