include "globals.mzn";

/***** Data (embedded from problem statement) *****/
int: capSmall = 20;
int: capLarge = 50;

int: oreNeeded = 2000;

int: minLarge = 10;              % at least 10 large wagons
int: smallAtLeastFactor = 2;     % small >= 2 * large

/***** Decision variables *****/
% Upper bounds are safe: even all-small solution needs oreNeeded/capSmall wagons
int: maxWagons = oreNeeded div capSmall;

var 0..maxWagons: small;
var 0..maxWagons: large;

/***** Constraints *****/
constraint capSmall * small + capLarge * large >= oreNeeded;
constraint small >= smallAtLeastFactor * large;
constraint large >= minLarge;

/***** Objective *****/
var 0..2*maxWagons: totalWagons = small + large;
solve minimize totalWagons;

/***** Output *****/
output [
  "small = ", show(small), "\n",
  "large = ", show(large), "\n",
  "totalWagons = ", show(totalWagons), "\n",
  "oreCarried = ", show(capSmall*small + capLarge*large), "\n"
];