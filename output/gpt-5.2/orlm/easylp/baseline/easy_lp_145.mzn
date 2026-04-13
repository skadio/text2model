int: maxWeight = 10000; % tons
int: tankWeight = 3;
int: aircraftWeight = 4;

int: minFirepower = 2000; % points
int: tankFirepowerCoeff = 2;
int: aircraftFirepowerCoeff = 1;

int: tankCost = 5000; % dollars per unit
int: aircraftCost = 3000;

var 0..maxWeight div tankWeight: tanks;
var 0..maxWeight div aircraftWeight: aircraft;

constraint tankWeight * tanks + aircraftWeight * aircraft <= maxWeight;
constraint tankFirepowerCoeff * tanks + aircraftFirepowerCoeff * aircraft >= minFirepower;

var int: totalCost = tankCost * tanks + aircraftCost * aircraft;

solve minimize totalCost;

output [
  "tanks = ", show(tanks), "\n",
  "aircraft = ", show(aircraft), "\n",
  "totalCost = $", show(totalCost), "\n"
];