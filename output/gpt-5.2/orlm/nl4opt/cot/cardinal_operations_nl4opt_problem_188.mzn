% Parameters (with values embedded)
int: heat_new = 10;
int: heat_old = 15;
int: kwh_new = 200;
int: kwh_old = 250;

int: min_apartments = 200;
int: max_kwh = 3500;

float: max_old_fraction = 0.35;
int: min_new = 5;

% Variables
% Upper bounds derived from electricity limit
int: ub_new = max_kwh div kwh_new; % 17
int: ub_old = max_kwh div kwh_old; % 14

var 0..ub_new: new_furnaces;
var 0..ub_old: old_furnaces;

var 0..(ub_new + ub_old): total_furnaces = new_furnaces + old_furnaces;

% Constraints
constraint new_furnaces >= min_new;

% Heating requirement
constraint heat_new * new_furnaces + heat_old * old_furnaces >= min_apartments;

% Electricity limit
constraint kwh_new * new_furnaces + kwh_old * old_furnaces <= max_kwh;

% At most 35% old model: old <= 0.35 * total
% Use integer form to avoid floats: 100*old <= 35*(new+old)
constraint 100 * old_furnaces <= 35 * (new_furnaces + old_furnaces);

% Objective
solve minimize total_furnaces;