% Parameters
int: N = 15;
set of int: CARS = 1..N;

array[CARS] of float: lambda =
  [4.0, 4.5, 5.0, 4.1, 2.4, 5.2, 3.7, 3.5, 3.2, 4.5, 2.3, 3.3, 3.8, 4.6, 3.0];

% Switch for the variant: if true, enforce max 30 meters on one side
bool: limit_one_side = true;
float: SIDE_MAX = 30.0;

% Big-M bounds for total length per side
float: sumL = sum(i in CARS)(lambda[i]);

% Variables
array[CARS] of var 0..1: x;         % x[i]=1 if car i parks on side A, else side B
var 0.0..sumL: LA;                  % total length on side A
var 0.0..sumL: LB;                  % total length on side B
var 0.0..sumL: T;                   % total street length occupied (max of LA and LB)

% Constraints
constraint LA = sum(i in CARS)(lambda[i] * x[i]);
constraint LB = sum(i in CARS)(lambda[i] * (1.0 - x[i]));

constraint T >= LA;
constraint T >= LB;

constraint (not limit_one_side) \/ (LA <= SIDE_MAX);

% Objective
solve minimize T;