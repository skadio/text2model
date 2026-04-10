% Parameters
int: max_residential = 15;
int: max_commercial = 10;
int: max_total_buildings = 20;

int: min_effort = 15;                % 2*x + 0.5*y >= 15
int: max_diff = 5;                   % |x - y| <= 5

int: cost_residential = 30000;
int: cost_commercial = 50000;

% Variables
var 0..max_residential: x;           % residential buildings
var 0..max_commercial: y;            % commercial buildings

% Constraints
constraint x + y <= max_total_buildings;

% Multiply by 2 to avoid fractions: 4*x + y >= 30
constraint 4 * x + y >= 2 * min_effort;

constraint abs(x - y) <= max_diff;

% Objective
solve minimize cost_residential * x + cost_commercial * y;