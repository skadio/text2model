% Parameters (with values embedded)
int: land_limit = 1000;
int: minX = 200;
int: minY = 150;
int: minZ = 100;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

% Variables
var minX..land_limit: acresX;
var minY..land_limit: acresY;
var minZ..land_limit: acresZ;

var 0..(land_limit * max([costX, costY, costZ])): total_cost;

% Constraints
constraint acresX + acresY + acresZ <= land_limit;

constraint total_cost = costX * acresX + costY * acresY + costZ * acresZ;

% Objective
solve minimize total_cost;