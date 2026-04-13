% Parameters (with values embedded)
int: cool_low = 12;
int: elec_low = 150;

int: cool_high = 17;
int: elec_high = 250;

int: min_units_cooled = 250;
int: max_electricity = 3400;

float: max_low_fraction = 0.30;
int: min_high = 7;

% Upper bounds for search (safe finite bounds from electricity limit)
int: max_low = max_electricity div elec_low;
int: max_high = max_electricity div elec_high;

% Variables
var 0..max_low: low;
var 0..max_high: high;
var 0..(max_low + max_high): total;

% Constraints
constraint total = low + high;

constraint cool_low * low + cool_high * high >= min_units_cooled;
constraint elec_low * low + elec_high * high <= max_electricity;

constraint high >= min_high;

% low-powered models are at most 30% of total: low <= 0.30 * total
% Use integer form: 10*low <= 3*total
constraint 10 * low <= 3 * total;

% Objective
solve minimize total;