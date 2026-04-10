% Taxi fleet selection: motorcycles vs sedans
% Maximize earnings subject to demand, pollution, and motorcycle share constraints.

include "globals.mzn";

% Data (embedded from problem statement)
int: cap_m = 30;
int: pol_m = 4;
int: earn_m = 100;

int: cap_s = 70;
int: pol_s = 15;
int: earn_s = 225;

int: min_people = 1200;
int: max_pollution = 199;      % "less than 200" => <= 199

% Decision variables: number of vehicles of each type
var 0..1000: m;  % motorcycles
var 0..1000: s;  % sedans

% Constraints
constraint cap_m * m + cap_s * s >= min_people;
constraint pol_m * m + pol_s * s <= max_pollution;

% At most 25% of vehicles can be motorcycles:
% m <= 0.25*(m+s)  <=>  4m <= m + s  <=>  3m <= s
constraint 3 * m <= s;

% Objective: maximize earnings per shift
var int: total_earn = earn_m * m + earn_s * s;

solve maximize total_earn;

output [
  "motorcycles = ", show(m), "\n",
  "sedans      = ", show(s), "\n",
  "people      = ", show(cap_m*m + cap_s*s), "\n",
  "pollution   = ", show(pol_m*m + pol_s*s), "\n",
  "earnings    = ", show(total_earn), "\n"
];