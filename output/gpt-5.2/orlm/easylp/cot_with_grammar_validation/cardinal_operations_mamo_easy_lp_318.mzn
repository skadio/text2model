% Parameters
int: weight_min = 2000;
int: volume_max = 3000;

int: wA = 2;
int: wB = 3;
int: wC = 4;

int: vA = 3;
int: vB = 2;
int: vC = 1;

int: diff_AB_min = 500;

int: cA = 7;
int: cB = 6;
int: cC = 5;

% Variables
var 0..1500: ShipA;
var 0..1500: ShipB;
var 0..3000: ShipC;
var 0..(cA*1500 + cB*1500 + cC*3000): total_cost;

% Constraints
constraint wA*ShipA + wB*ShipB + wC*ShipC >= weight_min;
constraint vA*ShipA + vB*ShipB + vC*ShipC <= volume_max;
constraint ShipA - ShipB >= diff_AB_min;

constraint total_cost = cA*ShipA + cB*ShipB + cC*ShipC;

% Objective
solve minimize total_cost;