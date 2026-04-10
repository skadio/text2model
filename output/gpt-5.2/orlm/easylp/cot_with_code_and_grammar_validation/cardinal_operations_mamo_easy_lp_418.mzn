% Parameters
int: power_X = 60;
int: power_Y = 90;

int: max_weighted_resource = 1200; % 2*X + 3*Y <= 1200
int: min_total_resource = 100;     % X + Y >= 100

% Variables
var 0..max_weighted_resource div 2: x; % resource units to plant X
var 0..max_weighted_resource div 3: y; % resource units to plant Y
var 0..power_Y * (max_weighted_resource div 3) + power_X * (max_weighted_resource div 2): total_power;

% Constraints
constraint 2*x + 3*y <= max_weighted_resource;
constraint x >= y;
constraint x + y >= min_total_resource;

constraint total_power = power_X * x + power_Y * y;

% Objective
solve minimize total_power;