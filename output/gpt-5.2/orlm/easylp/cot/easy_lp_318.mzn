% Parameters (with values embedded)
int: min_weight = 2000;
int: max_volume = 3000;
int: min_A_minus_B = 500;

int: wA = 2;
int: wB = 3;
int: wC = 4;

int: vA = 3;
int: vB = 2;
int: vC = 1;

int: costA = 7;
int: costB = 6;
int: costC = 5;

% Upper bounds derived from volume constraint (since all coefficients are positive)
int: ubA = max_volume div vA; % 1000
int: ubB = max_volume div vB; % 1500
int: ubC = max_volume div vC; % 3000

% Variables
var 0..ubA: ShipA;
var 0..ubB: ShipB;
var 0..ubC: ShipC;

var 0..(costA*ubA + costB*ubB + costC*ubC): TotalCost;

% Constraints
constraint TotalCost = costA*ShipA + costB*ShipB + costC*ShipC;

% Total weight at least 2000 tons
constraint wA*ShipA + wB*ShipB + wC*ShipC >= min_weight;

% Total volume at most 3000 cubic meters
constraint vA*ShipA + vB*ShipB + vC*ShipC <= max_volume;

% At least 500 more units from ShipA than from ShipB
constraint ShipA - ShipB >= min_A_minus_B;

% Objective
solve minimize TotalCost;