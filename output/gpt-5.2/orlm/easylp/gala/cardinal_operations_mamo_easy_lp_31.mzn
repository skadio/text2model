% Transportation trips minimization (all data embedded)

int: maxTrips = 10000;
int: minX = 3000;
int: minY = 2000;

% Costs in cents to keep everything integral
int: costX = 50;   % $0.5 = 50 cents
int: costY = 100;  % $1   = 100 cents

var minX..maxTrips: xTrips;
var minY..maxTrips: yTrips;

constraint xTrips + yTrips <= maxTrips;

var int: totalCostCents = costX * xTrips + costY * yTrips;

solve minimize totalCostCents;

% Rounded to nearest dollar: (cents + 50) div 100
output [
  "xTrips = ", show(xTrips), "\n",
  "yTrips = ", show(yTrips), "\n",
  "min_total_cost_rounded_dollars = ", show((totalCostCents + 50) div 100), "\n"
];