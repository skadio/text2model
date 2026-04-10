include "globals.mzn";

% Data (embedded from problem statement)
int: cool_low  = 12;
int: elec_low  = 150;
int: cool_high = 17;
int: elec_high = 250;

int: min_units = 250;
int: elec_avail = 3400;

float: max_low_frac = 0.30;
int: min_high = 7;

% Decision variables: number of units to buy
var 0..1000: low;
var 0..1000: high;

% Requirements
constraint cool_low * low + cool_high * high >= min_units;
constraint elec_low * low + elec_high * high <= elec_avail;

% At least 7 high-powered models
constraint high >= min_high;

% Low-powered models limited to at most 30% of total:
% low <= 0.30*(low+high)  <=>  0.70*low <= 0.30*high  <=>  7*low <= 3*high
constraint 7 * low <= 3 * high;

% Objective: minimize total number of air conditioners
solve minimize low + high;

output [
  "low = ", show(low), "\n",
  "high = ", show(high), "\n",
  "total = ", show(low + high), "\n",
  "cooled_units = ", show(cool_low * low + cool_high * high), "\n",
  "electricity_used = ", show(elec_low * low + elec_high * high), "\n"
];