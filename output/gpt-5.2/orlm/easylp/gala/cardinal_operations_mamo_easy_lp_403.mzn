include "globals.mzn";

% Decision variables (integer quantities of each unit type)
var 0..700: Tanks;
var 0..400: Aircrafts;
var 0..300: Ships;
var 0..250: Drones;

% Constraints
constraint Tanks + Aircrafts <= 1000;
constraint Ships + Drones <= 600;

constraint Tanks >= Ships + 200;                 % at least 200 more Tanks than Ships
constraint abs(Aircrafts - Drones) <= 50;        % no more than 50 difference

% Objective: minimize total support points
var int: total_support =
    4 * Tanks +
    3 * Aircrafts +
    5 * Ships +
    2 * Drones;

solve minimize total_support;

output [
  "Tanks=", show(Tanks), "\n",
  "Aircrafts=", show(Aircrafts), "\n",
  "Ships=", show(Ships), "\n",
  "Drones=", show(Drones), "\n",
  "Minimum total support points=", show(total_support), "\n"
];