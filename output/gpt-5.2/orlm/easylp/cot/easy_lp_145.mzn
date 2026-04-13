% Parameters (with values embedded)
int: maxWeight = 10000;
int: weightTank = 3;
int: weightAircraft = 4;

int: minFirepower = 2000;
int: firepowerCoefTank = 2;
int: firepowerCoefAircraft = 1;

int: costTank = 5000;
int: costAircraft = 3000;

% Variables
var 0..(maxWeight div weightTank): tanks;
var 0..(maxWeight div weightAircraft): aircraft;

var int: totalCost;

% Constraints
constraint weightTank * tanks + weightAircraft * aircraft <= maxWeight;
constraint firepowerCoefTank * tanks + firepowerCoefAircraft * aircraft >= minFirepower;

constraint totalCost = costTank * tanks + costAircraft * aircraft;

% Objective
solve minimize totalCost;