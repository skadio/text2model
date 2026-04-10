% Parameters
int: max_properties = 1000;
int: min_weighted_properties = 2000;
int: max_diff = 300;

int: cost_residential_k = 200; % thousand dollars per residential property
int: cost_commercial_k = 150;  % thousand dollars per commercial property

% Variables
var 0..max_properties: X; % residential properties
var 0..max_properties: Y; % commercial properties
var 0..(cost_residential_k*max_properties + cost_commercial_k*max_properties): total_cost_k;

% Constraints
constraint X + Y <= max_properties;
constraint 3*X + 2*Y >= min_weighted_properties;
constraint abs(X - Y) <= max_diff;

constraint total_cost_k = cost_residential_k*X + cost_commercial_k*Y;

% Objective
solve minimize total_cost_k;