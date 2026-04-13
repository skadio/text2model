% Chemistry experiments production planning (Integer Linear Programming)

include "globals.mzn";

% Data (embedded from the problem statement)
int: red_avail  = 80;
int: blue_avail = 70;
int: smelly_max = 10;

% Experiment 1: 3 red + 4 blue -> 5 green, produces 1 smelly
% Experiment 2: 5 red + 3 blue -> 6 green, produces 2 smelly
int: red1 = 3;  int: blue1 = 4;  int: green1 = 5;  int: smelly1 = 1;
int: red2 = 5;  int: blue2 = 3;  int: green2 = 6;  int: smelly2 = 2;

% Decision variables: number of times to run each experiment
% Simple safe upper bounds from resources
var 0..min(red_avail div red1, blue_avail div blue1): x1;
var 0..min(red_avail div red2, blue_avail div blue2): x2;

% Resource constraints
constraint red1 * x1 + red2 * x2 <= red_avail;
constraint blue1 * x1 + blue2 * x2 <= blue_avail;

% Smelly gas limit
constraint smelly1 * x1 + smelly2 * x2 <= smelly_max;

% Objective: maximize total green gas
var 0..(green1 * (red_avail div red1) + green2 * (red_avail div red2)): total_green;
constraint total_green = green1 * x1 + green2 * x2;

solve maximize total_green;

output [
  "Experiment1 = ", show(x1), "\n",
  "Experiment2 = ", show(x2), "\n",
  "TotalGreen  = ", show(total_green), "\n",
  "RedUsed     = ", show(red1*x1 + red2*x2), " / ", show(red_avail), "\n",
  "BlueUsed    = ", show(blue1*x1 + blue2*x2), " / ", show(blue_avail), "\n",
  "SmellyMade  = ", show(smelly1*x1 + smelly2*x2), " / ", show(smelly_max), "\n"
];