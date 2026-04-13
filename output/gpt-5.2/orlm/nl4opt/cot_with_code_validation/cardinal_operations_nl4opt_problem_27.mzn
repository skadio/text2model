% Parameters
int: cool_low = 12;
int: elec_low = 150;
int: cool_high = 17;
int: elec_high = 250;

int: min_units = 250;
int: max_elec = 3400;

float: max_low_frac = 0.30;
int: min_high = 7;

% Variables
var 0..ceil(int2float(min_units) / int2float(cool_low)): x_low;
var min_high..ceil(int2float(min_units) / int2float(cool_high)): x_high;
var 0..(ceil(int2float(min_units) / int2float(cool_low)) + ceil(int2float(min_units) / int2float(cool_high))): total;

% Constraints
constraint total = x_low + x_high;

constraint cool_low * x_low + cool_high * x_high >= min_units;
constraint elec_low * x_low + elec_high * x_high <= max_elec;

constraint int2float(x_low) <= max_low_frac * int2float(total);

% Objective
solve minimize total;