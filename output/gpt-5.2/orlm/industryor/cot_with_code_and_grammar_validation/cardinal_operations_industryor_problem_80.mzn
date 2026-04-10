% Parameters
int: N = 15;
set of int: CARS = 1..N;

array[CARS] of float: L = [4.0, 4.5, 5.0, 4.1, 2.4, 5.2, 3.7, 3.5, 3.2, 4.5, 2.3, 3.3, 3.8, 4.6, 3.0];

% Toggle for the additional constraint: if true, each side length <= 30m
bool: limit_one_side = false;
float: SIDE_LIMIT = 30.0;

% Discretization (decimeters) to keep the model linear/integer
int: SCALE = 10; % 1 unit = 0.1 m
array[CARS] of int: Li = [round(L[i] * SCALE) | i in CARS];

% Upper bound for occupied length: sum of all car lengths
int: SUM_L = sum(i in CARS)(Li[i]);

% Variables
array[CARS] of var 0..1: x;          % x[i]=1 if car i parks on side A, else side B
var 0..SUM_L: SA;                    % total length on side A (scaled)
var 0..SUM_L: SB;                    % total length on side B (scaled)
var 0..SUM_L: T;                     % total street length occupied = max(SA, SB) (scaled)

% Constraints
constraint
  SA = sum(i in CARS)(Li[i] * x[i]);

constraint
  SB = sum(i in CARS)(Li[i] * (1 - x[i]));

constraint
  T >= SA;

constraint
  T >= SB;

constraint
  (not limit_one_side) \/ (SA <= round(SIDE_LIMIT * SCALE));

constraint
  (not limit_one_side) \/ (SB <= round(SIDE_LIMIT * SCALE));

% Objective
solve minimize T;