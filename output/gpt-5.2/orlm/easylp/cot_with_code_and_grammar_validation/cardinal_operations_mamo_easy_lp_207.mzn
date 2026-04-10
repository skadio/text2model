% Parameters
int: B = 10000;
int: minX = 2000;
int: minY = 1500;
int: minZ = 500;

float: effX = 0.5;
float: effY = 0.3;
float: effZ = 0.2;

% Variables
var minX..B: X;
var minY..B: Y;
var minZ..B: Z;

var 0..B: total_cost;

% Constraints
constraint total_cost = X + Y + Z;

constraint total_cost <= B;

% (Minimum funding requirements are already enforced via variable bounds.)

% Objective
solve minimize total_cost;