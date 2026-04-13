% Parameters
int: chlorine_time = 1;
int: softener_time = 2;

int: min_chlorine = 200;
int: total_chemicals = 500;

% Variables
var 0..total_chemicals: C; % units of chlorine
var 0..total_chemicals: S; % units of water softener

var 0..(chlorine_time*total_chemicals + softener_time*total_chemicals): total_time;

% Constraints
constraint C + S = total_chemicals;
constraint C >= min_chlorine;

% "At most half as much chlorine as water softener": C <= S/2  <=>  2*C <= S
constraint 2 * C <= S;

% Total time (order doesn't matter if both must be applied; times add)
constraint total_time = chlorine_time * C + softener_time * S;

% Objective
solve minimize total_time;