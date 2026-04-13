% Parameters
int: Bmax = 5000;
int: reach_min = 2000;

int: coeffX = 5;
int: coeffY = -3;
int: coeffZ = 1;

int: extra_limit = 1000;

int: costX = 100;
int: costY = 50;
int: costZ = 20;

% Variables
var 0..Bmax: X;
var 0..Bmax: Y;
var 0..Bmax: Z;

var 0..(costX*Bmax + costY*Bmax + costZ*Bmax): total_cost;

% Constraints
constraint X + Y + Z <= Bmax;

constraint coeffX * X + coeffY * Y + coeffZ * Z >= reach_min;

% "X + Z cannot exceed twice Y by more than 1000"  =>  X + Z <= 2Y + 1000
constraint X + Z <= 2 * Y + extra_limit;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;