% Parameters (with values embedded)
int: metal_J = 5;
int: water_J = 8;
int: poll_J  = 3;

int: metal_P = 9;
int: water_P = 6;
int: poll_P  = 5;

int: water_max = 1500;
int: poll_max  = 1350;

% Variables
var 0..(water_max div water_J): J;  % number of process J runs
var 0..(water_max div water_P): P;  % number of process P runs

var 0..(metal_J*(water_max div water_J) + metal_P*(water_max div water_P)): total_metal;

% Constraints
constraint water_J * J + water_P * P <= water_max;
constraint poll_J  * J + poll_P  * P <= poll_max;

constraint total_metal = metal_J * J + metal_P * P;

% Objective
solve maximize total_metal;