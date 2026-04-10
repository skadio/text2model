% Parameters
int: nParts = 10;
set of int: PARTS = 1..nParts;

% Machines encoded as 1=A, 2=B, 3=C
int: nMachines = 3;
set of int: MACHINES = 1..nMachines;
int: A = 1;
int: B = 2;
int: C = 3;

% Unit processing costs cost[machine, part]
array[MACHINES, PARTS] of int: cost =
  array2d(MACHINES, PARTS,
    [ 10,  20,  30,  40,  50,  60,  70,  80,  90, 100,   % A
      15,  25,  35,  45,  55,  65,  75,  85,  95, 105,   % B
      20,  30,  40,  50,  60,  70,  80,  90, 100, 110 ]  % C
  );

% One-time setup costs (incurred if any part assigned to that machine)
array[MACHINES] of int: setup = [100, 135, 200];

% Constraint parameter: max number of part-types on machine C
int: maxTypesOnC = 3;


% Variables
% x[p,m] = 1 if part p is processed on machine m
array[PARTS, MACHINES] of var 0..1: x;

% y[m] = 1 if machine m is used (any part assigned to it), else 0
array[MACHINES] of var 0..1: y;

% Total cost (bounded)
var 0..1000000: totalCost;


% Constraints

%------------------------------------------------------------
% Assignment constraints: each part must be processed on exactly one machine
%------------------------------------------------------------
constraint
  forall(p in PARTS) (
    sum(m in MACHINES)(x[p,m]) = 1
  );

%------------------------------------------------------------
% Linking constraints: y[m] is 1 iff any part is assigned to machine m
% (x[p,m] <= y[m] ensures using a machine if any part is assigned to it)
%------------------------------------------------------------
constraint
  forall(m in MACHINES, p in PARTS) (
    x[p,m] <= y[m]
  );

%------------------------------------------------------------
% Logical constraint between part 1 and part 2 assignments
% If part 1 on A -> part 2 on B or C
% If part 1 on B or C -> part 2 on A
% (These equalities enforce the intended exclusive pairing.)
%------------------------------------------------------------
constraint x[1,A] = x[2,B] + x[2,C];
constraint x[1,B] + x[1,C] = x[2,A];

%------------------------------------------------------------
% Fixed assignments: parts 3,4,5 must be processed on A,B,C respectively
%------------------------------------------------------------
constraint x[3,A] = 1;
constraint x[4,B] = 1;
constraint x[5,C] = 1;

%------------------------------------------------------------
% Capacity/type limit: number of part-types processed on machine C <= maxTypesOnC
%------------------------------------------------------------
constraint
  sum(p in PARTS)(x[p,C]) <= maxTypesOnC;

%------------------------------------------------------------
% Total cost definition: processing cost + one-time setup cost for used machines
%------------------------------------------------------------
constraint
  totalCost =
    sum(p in PARTS, m in MACHINES)(cost[m,p] * x[p,m])
    + sum(m in MACHINES)(setup[m] * y[m]);


% Objective
solve minimize totalCost;