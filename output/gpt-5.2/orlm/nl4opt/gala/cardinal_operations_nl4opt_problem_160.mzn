% Toy factory planning: minimize total number of factories
% Data embedded from problem statement.

include "globals.mzn";

% Parameters
int: toys_medium = 50;
int: ops_medium  = 3;

int: toys_small  = 35;
int: ops_small   = 2;

int: toys_required = 250;
int: ops_available = 16;

% Upper bounds (safe tight bounds based on operator availability)
int: max_medium = ops_available div ops_medium; % floor(16/3)=5
int: max_small  = ops_available div ops_small;  % floor(16/2)=8

% Decision variables
var 0..max_medium: m;   % number of medium factories
var 0..max_small:  s;   % number of small factories

% Constraints
constraint toys_medium * m + toys_small * s >= toys_required;
constraint ops_medium  * m + ops_small  * s <= ops_available;

% Objective: minimize total number of factories
var 0..(max_medium + max_small): total_factories = m + s;
solve minimize total_factories;

output [
  "MediumFactories = ", show(m), "\n",
  "SmallFactories  = ", show(s), "\n",
  "TotalFactories  = ", show(total_factories), "\n",
  "ToysPerDay      = ", show(toys_medium*m + toys_small*s), "\n",
  "OperatorsUsed   = ", show(ops_medium*m + ops_small*s), "\n"
];