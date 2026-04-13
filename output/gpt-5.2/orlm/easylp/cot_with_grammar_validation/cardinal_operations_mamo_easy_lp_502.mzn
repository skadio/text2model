% Parameters
int: max_properties = 100;
int: min_residential = 10;
int: min_commercial  = 5;

float: roi_residential_frac = 0.30;
float: roi_commercial_frac  = 0.40;
float: roi_min = 30.0;

float: risk_residential_coef = 0.5;
float: risk_commercial_coef  = 0.2;
float: risk_max = 40.0;

int: cost_residential = 50000;
int: cost_commercial  = 70000;

% Variables
var min_residential..max_properties: X; % residential properties
var min_commercial..max_properties: Y;  % commercial properties

var 0..(cost_residential * max_properties + cost_commercial * max_properties): total_cost;

% Constraints
constraint X + Y <= max_properties;

constraint roi_residential_frac * int2float(X) + roi_commercial_frac * int2float(Y) >= roi_min;

constraint abs(risk_residential_coef * int2float(X) - risk_commercial_coef * int2float(Y)) <= risk_max;

constraint total_cost = cost_residential * X + cost_commercial * Y;

% Objective
solve minimize total_cost;