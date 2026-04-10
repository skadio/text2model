% Parameters
int: N = 10;
set of int: PARTS = 1..N;
set of int: MACH = 1..3; % 1=A, 2=B, 3=C

array[MACH, PARTS] of int: unit_cost =
  array2d(MACH, PARTS,
    [ 10, 20, 30, 40, 50, 60, 70, 80, 90, 100,   % A
      15, 25, 35, 45, 55, 65, 75, 85, 95, 105,   % B
      20, 30, 40, 50, 60, 70, 80, 90, 100, 110   % C
    ]);

array[MACH] of int: setup_cost = [100, 135, 200]; % dA,dB,dC

int: A = 1;
int: B = 2;
int: C = 3;

% Variables
array[PARTS, MACH] of var 0..1: x;      % x[p,m]=1 if part p processed on machine m
array[MACH] of var 0..1: y;             % y[m]=1 if any part processed on machine m

var int: total_cost;

% Constraints
constraint
  forall(p in PARTS)(
    sum(m in MACH)(x[p,m]) = 1
  );

constraint
  forall(p in PARTS, m in MACH)(
    x[p,m] <= y[m]
  );

% Conditional relationship between part 1 and part 2
constraint
  x[1,A] = x[2,B] + x[2,C];
constraint
  x[1,B] + x[1,C] = x[2,A];

% Fixed assignments: part 3->A, part 4->B, part 5->C
constraint x[3,A] = 1;
constraint x[3,B] = 0;
constraint x[3,C] = 0;

constraint x[4,A] = 0;
constraint x[4,B] = 1;
constraint x[4,C] = 0;

constraint x[5,A] = 0;
constraint x[5,B] = 0;
constraint x[5,C] = 1;

% Machine C processes at most 3 part types
constraint sum(p in PARTS)(x[p,C]) <= 3;

% Total cost definition
constraint
  total_cost =
    sum(p in PARTS, m in MACH)(unit_cost[m,p] * x[p,m])
    + sum(m in MACH)(setup_cost[m] * y[m]);

% Objective
solve minimize total_cost;