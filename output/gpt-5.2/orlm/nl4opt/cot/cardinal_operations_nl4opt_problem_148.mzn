% Parameters (with values embedded)
int: nFactories = 2;
set of int: F = 1..nFactories;

int: NORTH = 1;
int: WEST  = 2;

int: inj_per_hour_north = 800;
int: cream_per_hour_north = 700;
int: inj_per_hour_west = 650;
int: cream_per_hour_west = 750;

int: plastic_per_hour_north = 40;
int: plastic_per_hour_west = 35;

int: plastic_available = 60000;

int: inj_required = 800000;
int: cream_required = 700000;

array[F] of int: inj_per_hour = [inj_per_hour_north, inj_per_hour_west];
array[F] of int: cream_per_hour = [cream_per_hour_north, cream_per_hour_west];
array[F] of int: plastic_per_hour = [plastic_per_hour_north, plastic_per_hour_west];

% Variables
array[F] of var 0..2000: hours;   % safe upper bound (enforced; does not cut off optimum)
var 0..4000: total_hours;

% Constraints
constraint total_hours = sum(f in F)(hours[f]);

constraint sum(f in F)(inj_per_hour[f] * hours[f]) >= inj_required;
constraint sum(f in F)(cream_per_hour[f] * hours[f]) >= cream_required;
constraint sum(f in F)(plastic_per_hour[f] * hours[f]) <= plastic_available;

% Objective
solve minimize total_hours;