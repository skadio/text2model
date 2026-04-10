% Parameters
int: flour_available = 150;
int: liquid_available = 100;
int: waste_max = 30;

int: flour_b1 = 4;
int: liquid_b1 = 6;
int: slime_b1 = 5;
int: waste_b1 = 4;

int: flour_b2 = 6;
int: liquid_b2 = 3;
int: slime_b2 = 3;
int: waste_b2 = 2;

% Variables
var 0..min(flour_available div flour_b1, min(liquid_available div liquid_b1, waste_max div waste_b1)): x1;
var 0..min(flour_available div flour_b2, min(liquid_available div liquid_b2, waste_max div waste_b2)): x2;

% Constraints
constraint flour_b1 * x1 + flour_b2 * x2 <= flour_available;
constraint liquid_b1 * x1 + liquid_b2 * x2 <= liquid_available;
constraint waste_b1 * x1 + waste_b2 * x2 <= waste_max;

% Objective
solve maximize slime_b1 * x1 + slime_b2 * x2;