% Parameters
int: flour_avail = 150;
int: liquid_avail = 100;
int: waste_max = 30;

int: flour1 = 4;
int: liquid1 = 6;
int: slime1 = 5;
int: waste1 = 4;

int: flour2 = 6;
int: liquid2 = 3;
int: slime2 = 3;
int: waste2 = 2;

% Variables
var 0..min(floor(flour_avail div flour1), min(liquid_avail div liquid1, waste_max div waste1)): x1;
var 0..min(floor(flour_avail div flour2), min(liquid_avail div liquid2, waste_max div waste2)): x2;

var 0..(slime1 * (flour_avail div flour1) + slime2 * (flour_avail div flour2)): total_slime;

% Constraints
constraint flour1 * x1 + flour2 * x2 <= flour_avail;
constraint liquid1 * x1 + liquid2 * x2 <= liquid_avail;
constraint waste1 * x1 + waste2 * x2 <= waste_max;

constraint total_slime = slime1 * x1 + slime2 * x2;

% Objective
solve maximize total_slime;