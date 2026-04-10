include "globals.mzn";

% Data (embedded from problem statement)
int: cap4 = 60;      % luggage/day moved by a 4-wheeler
int: pol4 = 30;      % pollutant/day produced by a 4-wheeler
int: cap3 = 40;      % luggage/day moved by a 3-wheeler
int: pol3 = 15;      % pollutant/day produced by a 3-wheeler

int: min_luggage = 1000;  % at least this many luggage/day
int: max_pollutant = 430; % at most this many pollutant units/day

% Decision variables: number of vehicles to buy (nonnegative integers)
var 0..1000: n4;  % number of 4-wheelers
var 0..1000: n3;  % number of 3-wheelers

% Constraints
constraint cap4 * n4 + cap3 * n3 >= min_luggage;
constraint pol4 * n4 + pol3 * n3 <= max_pollutant;

% Objective: minimize total number of vehicles
var 0..2000: total = n4 + n3;
solve minimize total;

output [
  "4-wheelers = ", show(n4), "\n",
  "3-wheelers = ", show(n3), "\n",
  "Total vehicles = ", show(total), "\n",
  "Luggage/day = ", show(cap4*n4 + cap3*n3), "\n",
  "Pollutant/day = ", show(pol4*n4 + pol3*n3), "\n"
];