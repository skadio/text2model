% Parameters
int: max_total_properties = 1000;
int: min_weighted_diversification = 2000;
int: max_difference = 300;

int: cost_residential_k = 200; % in thousand dollars
int: cost_commercial_k = 150;  % in thousand dollars

% Variables
var 0..max_total_properties: X; % residential properties
var 0..max_total_properties: Y; % commercial properties

var 0..(cost_residential_k*max_total_properties + cost_commercial_k*max_total_properties): total_cost_k;

% Constraints
constraint X + Y <= max_total_properties;

constraint 3*X + 2*Y >= min_weighted_diversification;

constraint abs(X - Y) <= max_difference;

constraint total_cost_k = cost_residential_k*X + cost_commercial_k*Y;

% Objective
solve minimize total_cost_k;