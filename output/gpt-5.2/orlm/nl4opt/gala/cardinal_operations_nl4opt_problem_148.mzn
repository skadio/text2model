% Clinical firm production planning (minimize total operating hours)
% Data embedded from problem statement.

include "globals.mzn";

% Production rates (grams per hour)
int: inj_north = 800;
int: cream_north = 700;
int: inj_west  = 650;
int: cream_west = 750;

% Plastic usage (units per hour)
int: plastic_north = 40;
int: plastic_west  = 35;

% Resource availability and demand requirements
int: plastic_avail = 60000;
int: inj_min = 800000;
int: cream_min = 700000;

% Decision variables: hours to run each factory (nonnegative integers)
var 0..plastic_avail div min(plastic_north, plastic_west): h_north;
var 0..plastic_avail div min(plastic_north, plastic_west): h_west;

% Constraints
constraint plastic_north * h_north + plastic_west * h_west <= plastic_avail;
constraint inj_north * h_north + inj_west * h_west >= inj_min;
constraint cream_north * h_north + cream_west * h_west >= cream_min;

% Objective: minimize total hours
var int: total_hours = h_north + h_west;
solve minimize total_hours;

output [
  "Hours (north) = ", show(h_north), "\n",
  "Hours (west)  = ", show(h_west), "\n",
  "Total hours   = ", show(total_hours), "\n",
  "Plastic used  = ", show(plastic_north*h_north + plastic_west*h_west), " / ", show(plastic_avail), "\n",
  "Injections    = ", show(inj_north*h_north + inj_west*h_west), " >= ", show(inj_min), "\n",
  "Cream         = ", show(cream_north*h_north + cream_west*h_west), " >= ", show(cream_min), "\n"
];