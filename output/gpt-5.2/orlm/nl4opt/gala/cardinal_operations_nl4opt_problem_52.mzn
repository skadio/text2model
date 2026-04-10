% Snack suitcases optimization (all data embedded)

include "globals.mzn";

% Data
int: capSmall = 50;
int: capLarge = 80;

int: maxSmallAvail = 70;
int: maxLargeAvail = 50;

int: minLarge = 15;
int: maxTotalSuitcases = 70;

% Decision variables
var 0..maxSmallAvail: small;
var 0..maxLargeAvail: large;

% Constraints
constraint 2 * large <= small;                    % at least twice as many small as large
constraint large >= minLarge;                     % must send at least 15 large
constraint small + large <= maxTotalSuitcases;    % at most 70 suitcases total

% Objective: maximize delivered snacks
var int: totalSnacks = capSmall * small + capLarge * large;

solve maximize totalSnacks;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "totalSuitcases = ", show(small + large), "\n",
  "totalSnacks = ", show(totalSnacks), "\n"
];