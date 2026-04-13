% Parameters (with values embedded)
int: flour_avail = 150;
int: liquid_avail = 100;
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
var 0..min(min(floor(flour_avail div flour_b1), floor(liquid_avail div liquid_b1)), floor(waste_max div waste_b1)): x1; % number of beaker 1 uses
var 0..min(min(floor(flour_avail div flour_b2), floor(liquid_avail div liquid_b2)), floor(waste_max div waste_b2)): x2; % number of beaker 2 uses

var 0..(slime_b1*(flour_avail div flour_b1) + slime_b2*(flour_avail div flour_b2)): total_slime;

% Constraints
constraint flour_b1 * x1 + flour_b2 * x2 <= flour_avail;
constraint liquid_b1 * x1 + liquid_b2 * x2 <= liquid_avail;
constraint waste_b1 * x1 + waste_b2 * x2 <= waste_max;

constraint total_slime = slime_b1 * x1 + slime_b2 * x2;

% Objective
solve maximize total_slime;