% Air conditioner purchase optimization (all data embedded)

int: cool_low = 12;
int: power_low = 150;

int: cool_high = 17;
int: power_high = 250;

int: min_units_to_cool = 250;
int: max_electricity = 3400;

float: max_low_fraction = 0.30;
int: min_high = 7;

% Decision variables
var 0..1000: low;
var 0..1000: high;

% Constraints
constraint cool_low * low + cool_high * high >= min_units_to_cool;
constraint power_low * low + power_high * high <= max_electricity;
constraint high >= min_high;

% Low-powered models limited to at most 30% of total:
% low <= 0.30*(low+high)  <=>  0.70*low <= 0.30*high  <=>  7*low <= 3*high
constraint 7 * low <= 3 * high;

% Objective: minimize total number of air conditioners
solve minimize low + high;

output [
  "low=", show(low), "\n",
  "high=", show(high), "\n",
  "total=", show(low + high), "\n",
  "cooled_units=", show(cool_low*low + cool_high*high), "\n",
  "electricity_used=", show(power_low*low + power_high*high), "\n"
];