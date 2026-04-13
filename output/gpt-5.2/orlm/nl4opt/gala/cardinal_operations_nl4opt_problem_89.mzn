include "globals.mzn";

% Data (embedded from the problem statement)
int: ao_blue = 3;     % anti-oxidants per pack of blueberries
int: min_blue = 5;    % minerals per pack of blueberries
int: sug_blue = 5;    % sugar (grams) per pack of blueberries

int: ao_straw = 1;    % anti-oxidants per pack of strawberries
int: min_straw = 7;   % minerals per pack of strawberries
int: sug_straw = 7;   % sugar (grams) per pack of strawberries

int: req_ao = 90;
int: req_min = 100;

% Decision variables: number of packs (nonnegative integers)
var 0..1000: blue;
var 0..1000: straw;

% Requirements
constraint ao_blue * blue + ao_straw * straw >= req_ao;
constraint min_blue * blue + min_straw * straw >= req_min;

% Seasonal recommendation: at least 3 times as many strawberry packs as blueberry packs
constraint straw >= 3 * blue;

% Objective: minimize sugar intake
var 0..10000000: total_sugar = sug_blue * blue + sug_straw * straw;

solve minimize total_sugar;

output [
  "blueberry_packs = ", show(blue), "\n",
  "strawberry_packs = ", show(straw), "\n",
  "total_sugar_g = ", show(total_sugar), "\n",
  "anti_oxidants = ", show(ao_blue * blue + ao_straw * straw), "\n",
  "minerals = ", show(min_blue * blue + min_straw * straw), "\n"
];