% Parameters
int: max_area = 500;
int: min_diverse = 200;
int: max_diff_yz = 50;
int: min_margin_xz = 100;

int: costX = 100;
int: costY = 50;
int: costZ = 75;

% Variables
var 0..max_area: X;
var 0..max_area: Y;
var 0..max_area: Z;

var 0..(max_area * max(costX, max(costY, costZ))): total_cost;

% Constraints
constraint X + Y + Z <= max_area;
constraint 2 * X + Y >= min_diverse;
constraint abs(Y - Z) <= max_diff_yz;

/* "the area allocated to crop X must be at least twice that of half of crop Z's area by at least 100 acres"
   Interpreted as: X >= 2*(Z/2) + 100 => X >= Z + 100
*/
constraint X >= Z + min_margin_xz;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;