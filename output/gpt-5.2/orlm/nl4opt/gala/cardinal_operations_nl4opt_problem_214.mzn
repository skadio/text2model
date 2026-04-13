% Car shipment on planes (embed all data in model)

include "globals.mzn";

int: capLarge = 30;
int: capSmall = 10;
int: demand   = 300;

% Decision variables: number of large and small planes
var 0..demand div capLarge + 10: large;
var 0..demand div capSmall + 10: small;

% Total planes to minimize
var 0..1000: total = large + small;

% Constraints
constraint capLarge * large + capSmall * small >= demand;
constraint large < small;

solve minimize total;

output [
  "Large planes = ", show(large), "\n",
  "Small planes = ", show(small), "\n",
  "Total planes = ", show(total), "\n",
  "Cars shipped = ", show(capLarge*large + capSmall*small), "\n"
];