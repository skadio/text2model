% Parameters
int: max_units = 10;
int: cost_res = 50000;
int: cost_com = 75000;

% Demand constraint scaled by 10 to avoid decimals:
% 0.6*X + 0.4*Y >= 5  <=>  6*X + 4*Y >= 50
int: w_res = 6;
int: w_com = 4;
int: demand_rhs = 50;

% Variables
var 0..max_units: X; % residential units
var 0..max_units: Y; % commercial units

% Constraints
constraint X + Y <= max_units;
constraint w_res * X + w_com * Y >= demand_rhs;

% Objective
var 0..(cost_res*max_units + cost_com*max_units): total_cost;
constraint total_cost = cost_res * X + cost_com * Y;

solve minimize total_cost;