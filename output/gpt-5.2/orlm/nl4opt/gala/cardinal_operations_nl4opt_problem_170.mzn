% Honey transport optimization (all data embedded)

% Parameters
int: capSmall = 5;
int: capLarge = 20;

int: maxSmallAvail = 300;
int: maxLargeAvail = 100;

int: maxTotalBottles = 200;
int: minLargeUsed = 50;

% Decision variables
var 0..maxSmallAvail: small;
var 0..maxLargeAvail: large;

% Constraints
constraint small + large <= maxTotalBottles;
constraint large >= minLargeUsed;
constraint small >= 2 * large;

% Objective: maximize transported honey
var int: totalHoney = capSmall * small + capLarge * large;
solve maximize totalHoney;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "totalBottles = ", show(small + large), "\n",
  "totalHoney = ", show(totalHoney), "\n"
];