% Parameters
int: N = 10;
set of int: PARTS = 1..N;

set of int: MACH = 1..3; % 1=A, 2=B, 3=C

array[MACH, PARTS] of int: unitCost =
  array2d(MACH, PARTS,
  [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100,   % A
    15, 25, 35, 45, 55, 65, 75, 85, 95, 105,   % B
    20, 30, 40, 50, 60, 70, 80, 90, 100, 110   % C
  ]);

array[MACH] of int: setupCost = [100, 135, 200]; % d_A, d_B, d_C

% Variables
array[PARTS, MACH] of var 0..1: x;      % x[p,m]=1 if part p is processed on machine m
array[MACH] of var 0..1: y;             % y[m]=1 if machine m is used (any part assigned)

% Constraints
constraint
  forall(p in PARTS) (
    sum(m in MACH)(x[p,m]) = 1
  );

constraint
  forall(p in PARTS, m in MACH) (
    x[p,m] <= y[m]
  );

% If part 1 on A then part 2 on B or C; else (part 1 on B or C) then part 2 on A
constraint x[1,1] = x[2,2] + x[2,3];
constraint x[1,2] + x[1,3] = x[2,1];

% Parts 3,4,5 fixed to A,B,C respectively
constraint x[3,1] = 1 /\ x[3,2] = 0 /\ x[3,3] = 0;
constraint x[4,1] = 0 /\ x[4,2] = 1 /\ x[4,3] = 0;
constraint x[5,1] = 0 /\ x[5,2] = 0 /\ x[5,3] = 1;

% At most 3 types of parts processed on machine C
constraint sum(p in PARTS)(x[p,3]) <= 3;

% Objective
solve minimize
  sum(p in PARTS, m in MACH)(unitCost[m,p] * x[p,m]) +
  sum(m in MACH)(setupCost[m] * y[m]);