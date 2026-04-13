% Real estate investment minimization model (all data embedded)

int: max_total_properties = 50;

int: cost_residential = 10000;
int: cost_commercial  = 15000;
int: cost_industrial  = 20000;

int: max_residential = 20;
int: max_commercial  = 15;
int: max_industrial  = 25;

var 0..max_residential: X; % residential
var 0..max_commercial:  Y; % commercial
var 0..max_industrial:  Z; % industrial

constraint X + Y + Z <= max_total_properties;

% Residential should be at least twice commercial
constraint X >= 2 * Y;

% Total number of residential and commercial properties should be at least 30
constraint X + Y >= 30;

% Commercial + industrial should not exceed 40
constraint Y + Z <= 40;

var int: total_cost = cost_residential * X + cost_commercial * Y + cost_industrial * Z;

solve minimize total_cost;

output [
  "X (residential) = ", show(X), "\n",
  "Y (commercial)  = ", show(Y), "\n",
  "Z (industrial)  = ", show(Z), "\n",
  "Total properties = ", show(X+Y+Z), "\n",
  "Minimum investment cost ($) = ", show(total_cost), "\n"
];