% Parameters (with values embedded)
int: large_capacity = 30;
int: small_capacity = 10;
int: demand = 300;

% Variables
var 0..demand div large_capacity + 10: L;  % number of large planes
var 0..demand div small_capacity + 10: S;  % number of small planes

% Constraints
constraint L < S;
constraint large_capacity * L + small_capacity * S >= demand;

% Objective
solve minimize L + S;