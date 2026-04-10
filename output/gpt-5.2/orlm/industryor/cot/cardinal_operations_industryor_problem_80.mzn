% Parameters (with values embedded)
int: N = 15;
set of int: CARS = 1..N;

% Car lengths in decimeters (to keep everything integer)
array[CARS] of int: L_dm = [
  40, 45, 50, 41, 24, 52, 37, 35, 32, 45, 23, 33, 38, 46, 30
];

% Optional side-capacity (30 meters = 300 dm). Set to true to enforce.
bool: enforce_cap = true;
int: CAP_dm = 300;

% Upper bound on objective (max possible occupied length if all cars on one side)
int: U_dm = sum(i in CARS)(L_dm[i]);

% Variables
array[CARS] of var 0..1: left;        % 1 if car i parks on left side, else right
var 0..U_dm: S_left;                  % total length on left (dm)
var 0..U_dm: S_right;                 % total length on right (dm)
var 0..U_dm: T;                       % occupied street length = max(S_left, S_right) (dm)

% Constraints
constraint S_left  = sum(i in CARS)(L_dm[i] * left[i]);
constraint S_right = sum(i in CARS)(L_dm[i] * (1 - left[i]));

% T = max(S_left, S_right)
constraint T >= S_left;
constraint T >= S_right;

% Capacity on one side (if enforced)
constraint (not enforce_cap) \/ (S_left <= CAP_dm);
constraint (not enforce_cap) \/ (S_right <= CAP_dm);

% Objective
solve minimize T;