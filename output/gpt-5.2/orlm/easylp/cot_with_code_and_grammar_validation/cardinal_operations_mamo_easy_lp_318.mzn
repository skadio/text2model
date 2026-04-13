% Parameters
int: min_weight = 2000;
int: max_volume = 3000;

int: wA = 2;
int: wB = 3;
int: wC = 4;

int: vA = 3;
int: vB = 2;
int: vC = 1;

int: costA = 7;
int: costB = 6;
int: costC = 5;

int: min_diff_AB = 500;

% Variables
var 0..1000: ShipA;
var 0..1000: ShipB;
var 0..1000: ShipC;

var 0..10000000: total_cost;

% Constraints
constraint wA*ShipA + wB*ShipB + wC*ShipC >= min_weight;
constraint vA*ShipA + vB*ShipB + vC*ShipC <= max_volume;
constraint ShipA - ShipB >= min_diff_AB;

constraint total_cost = costA*ShipA + costB*ShipB + costC*ShipC;

% Objective
solve minimize total_cost;