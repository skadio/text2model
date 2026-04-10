% Parameters (with values embedded)
int: n = 4;
set of int: T = 1..n;

int: ROBOT = 1;
int: CAR = 2;
int: BLOCKS = 3;
int: DOLL = 4;

array[T] of int: profit = [15, 8, 12, 5];

int: plastic_avail = 1200;
array[T] of int: plastic_req = [30, 10, 20, 15];

int: elec_avail = 800;
array[T] of int: elec_req = [8, 5, 3, 2];

int: M = 1000; % big-M upper bound on production when "manufactured"

% Variables
array[T] of var 0..M: x;        % quantity produced of each toy type
array[T] of var bool: y;        % 1 if that toy type is manufactured (produced > 0)

% Constraints
constraint forall(t in T) (
  x[t] <= M * bool2int(y[t])
);

constraint sum(t in T)(plastic_req[t] * x[t]) <= plastic_avail;
constraint sum(t in T)(elec_req[t] * x[t]) <= elec_avail;

% If manufacture robots, then not manufacture dolls
constraint y[ROBOT] + y[DOLL] <= 1;

% If manufacture model cars, then also manufacture building blocks
constraint y[CAR] <= y[BLOCKS];

% Dolls manufactured cannot exceed model cars manufactured
constraint x[DOLL] <= x[CAR];

% Objective
solve maximize sum(t in T)(profit[t] * x[t]);