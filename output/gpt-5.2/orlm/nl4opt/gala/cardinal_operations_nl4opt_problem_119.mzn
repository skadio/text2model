% Mail delivery by regular and speed boats: minimize gas
include "globals.mzn";

% Data (embedded from problem statement)
int: demand = 1000;

int: cap_regular = 20;
int: gas_regular = 10;
int: cap_speed   = 30;
int: gas_speed   = 20;

int: max_regular_trips = 20;

% Decision variables
var 0..1000: r;   % number of regular boat trips
var 0..1000: s;   % number of speed boat trips

% Constraints
constraint r <= max_regular_trips;

% Must deliver at least the required mail pieces
constraint cap_regular * r + cap_speed * s >= demand;

% At least 50% of trips are speed: s >= r
constraint s >= r;

% Objective: minimize total gas consumed
var 0..1000000: total_gas = gas_regular * r + gas_speed * s;

solve minimize total_gas;

output [
  "Regular trips = ", show(r), "\n",
  "Speed trips   = ", show(s), "\n",
  "Total gas     = ", show(total_gas), " liters\n",
  "Total capacity delivered = ", show(cap_regular*r + cap_speed*s), " pieces\n"
];