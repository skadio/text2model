% Parameters (with values embedded)
int: wash_top = 50;
int: wash_front = 75;
int: kwh_top = 85;
int: kwh_front = 100;

int: min_items = 5000;
int: max_kwh = 7000;

float: max_frac_top = 0.40;
int: min_front_machines = 10;

% Variable bounds (derived from constraints)
int: max_top_by_energy = max_kwh div kwh_top;      % 7000/85 = 82
int: max_front_by_energy = max_kwh div kwh_front; % 7000/100 = 70
int: max_machines = max_top_by_energy + max_front_by_energy;

% Variables
var 0..max_top_by_energy: top;
var min_front_machines..max_front_by_energy: front;
var 0..max_machines: total;

% Constraints
constraint total = top + front;

% Must be able to wash at least the required items per day
constraint wash_top * top + wash_front * front >= min_items;

% Available energy per day
constraint kwh_top * top + kwh_front * front <= max_kwh;

% At most 40% of machines can be top-loading: top <= 0.4 * total
constraint 5 * top <= 2 * total;

% Objective
solve minimize total;