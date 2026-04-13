% Glacial water transport optimization (all data embedded)

int: capSmall = 40;
int: capLarge = 100;

int: maxSmallAvail = 30;
int: maxLargeAvail = 10;

int: maxTotalKegs = 25;
int: minLarge = 5;

% Decision variables: number of kegs used
var 0..maxSmallAvail: small;
var 0..maxLargeAvail: large;

% Constraints
constraint small + large <= maxTotalKegs;
constraint large >= minLarge;

% At least twice as many small kegs as large kegs
constraint small >= 2 * large;

% Objective: maximize transported water (liters)
var int: totalLiters = capSmall * small + capLarge * large;

solve maximize totalLiters;

output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "totalLiters = ", show(totalLiters), "\n"
];