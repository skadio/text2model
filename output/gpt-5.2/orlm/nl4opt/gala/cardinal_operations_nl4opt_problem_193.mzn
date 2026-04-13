include "globals.mzn";

% Data (embedded as requested)
int: capSmall = 20;
int: capLarge = 50;
int: demand = 500;
int: maxLargePercent = 20; % percent

% Decision variables
var 0..demand div capSmall + demand div capLarge + 100: smallBuses;
var 0..demand div capLarge + 100: largeBuses;
var 0..demand div capSmall + demand div capLarge + 200: totalBuses;

% Linking
constraint totalBuses = smallBuses + largeBuses;

% Capacity requirement
constraint capSmall * smallBuses + capLarge * largeBuses >= demand;

% At most 20% of the buses can be large:
% largeBuses / totalBuses <= 0.2  <=>  100*largeBuses <= 20*totalBuses
% Also implies totalBuses > 0 when largeBuses > 0; but demand already forces buses.
constraint 100 * largeBuses <= maxLargePercent * totalBuses;

solve minimize totalBuses;

output [
  "smallBuses = ", show(smallBuses), "\n",
  "largeBuses = ", show(largeBuses), "\n",
  "totalBuses = ", show(totalBuses), "\n",
  "capacity   = ", show(capSmall*smallBuses + capLarge*largeBuses), "\n"
];