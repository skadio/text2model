include "globals.mzn";

% Data (embedded from problem statement)
float: t_coconut = 0.7;      % minutes per unit
float: t_lavender = 0.9;     % minutes per unit

int: min_coconut = 300;
int: max_each = 550;         % at most 550 units of each ingredient
int: max_ratio = 3;          % coconut <= 3 * lavender

% Decision variables: units to add
var 0..max_each: coconut;
var 0..max_each: lavender;

% Constraints
constraint coconut >= min_coconut;
constraint coconut <= max_each;
constraint lavender <= max_each;

% "at most thrice the amount of coconut oil as lavenders"
constraint coconut <= max_ratio * lavender;

% Objective: minimize total time for mixture to be effective
var float: total_time = t_coconut * int2float(coconut) + t_lavender * int2float(lavender);

solve minimize total_time;

output [
  "coconut = ", show(coconut), "\n",
  "lavender = ", show(lavender), "\n",
  "total_time = ", show(total_time), " minutes\n"
];