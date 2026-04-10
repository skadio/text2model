% Parameters
int: cool_low = 12;
int: cool_high = 17;
int: elec_low = 150;
int: elec_high = 250;

int: min_units = 250;
int: elec_avail = 3400;

int: min_high = 7;
int: low_pct_num = 30;
int: low_pct_den = 100;

% Variables
var 0..1000: x_low;
var 0..1000: x_high;
var 0..2000: total_ac;

% Constraints
constraint total_ac = x_low + x_high;

constraint cool_low * x_low + cool_high * x_high >= min_units;
constraint elec_low * x_low + elec_high * x_high <= elec_avail;

constraint x_high >= min_high;

% Low-powered models limited to 30% of total: x_low <= 0.30 * (x_low + x_high)
% Use integer-safe linear form: 100*x_low <= 30*(x_low + x_high)  <=> 70*x_low <= 30*x_high
constraint (low_pct_den - low_pct_num) * x_low <= low_pct_num * x_high;

% Objective
solve minimize total_ac;