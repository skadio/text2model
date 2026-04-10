% Parameters
int: max_acres = 1000;                 % Total available acres
int: fertility_min = 800;              % Minimum required for fertility constraint

int: wheat_cost = 4;                   % Cost per acre for wheat ($/acre)
int: corn_cost  = 3;                   % Cost per acre for corn ($/acre)

int: fert_wheat_coeff = 2;             % Coefficient of wheat in fertility constraint
int: fert_corn_coeff  = 4;             % Coefficient of corn in fertility constraint

int: degr_wheat_coeff = 3;             % Coefficient of wheat in degradation constraint
int: degr_corn_coeff  = 1;             % Coefficient of corn in degradation constraint
int: degr_max = 500;                   % Maximum allowed degradation expression value

% Variables
var 0..max_acres: wheat_acres;         % Acres planted with wheat (integer)
var 0..max_acres: corn_acres;          % Acres planted with corn (integer)

var 0..(wheat_cost*max_acres + corn_cost*max_acres): total_cost; % Total cost ($)

% Constraints
% Link total_cost to planting decisions
constraint
  total_cost = wheat_cost * wheat_acres + corn_cost * corn_acres;

% Land capacity: total planted acres cannot exceed available acres
constraint
  wheat_acres + corn_acres <= max_acres;

% Soil fertility constraint: weighted sum must meet minimum requirement
constraint
  fert_wheat_coeff * wheat_acres + fert_corn_coeff * corn_acres >= fertility_min;

% Soil degradation constraint: limit on linear expression difference
constraint
  degr_wheat_coeff * wheat_acres - degr_corn_coeff * corn_acres <= degr_max;

% Objective
solve minimize total_cost;