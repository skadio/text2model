% Parameters
int: max_total_properties = 50;

int: cost_residential = 10000;
int: cost_commercial  = 15000;
int: cost_industrial  = 20000;

int: max_residential = 20;
int: max_commercial  = 15;
int: max_industrial  = 25;

int: min_residential_plus_commercial = 30;
int: max_commercial_plus_industrial  = 40;

% Variables
var 0..max_residential: X; % residential
var 0..max_commercial:  Y; % commercial
var 0..max_industrial:  Z; % industrial

var 0..(max_residential*cost_residential + max_commercial*cost_commercial + max_industrial*cost_industrial): total_cost;

% Constraints
constraint X + Y + Z <= max_total_properties;

constraint X + Y >= min_residential_plus_commercial;

constraint Y + Z <= max_commercial_plus_industrial;

constraint total_cost = cost_residential * X + cost_commercial * Y + cost_industrial * Z;

% Objective
solve minimize total_cost;