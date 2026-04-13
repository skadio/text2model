% Parameters
int: C;
int: K;
array[1..K] of int: Value;
array[1..K] of int: Size;

% Variables
array[1..K] of var 0..1: x;
var 0..sum(Value): total_value;

% Constraints
constraint forall(k in 1..K)(Value[k] >= 0 /\ Size[k] >= 0);
constraint sum(k in 1..K)(Size[k] * x[k]) <= C;
constraint total_value = sum(k in 1..K)(Value[k] * x[k]);

% Objective
solve maximize total_value;