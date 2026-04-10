% Parameters
int: nParts = 10;                       % number of parts
set of int: PARTS = 1..nParts;          % index set of parts

int: nMachines = 3;                     % number of machines
set of int: MACHINES = 1..nMachines;    % 1=A, 2=B, 3=C

int: A = 1;
int: B = 2;
int: C = 3;

% Unit processing costs (rows: A,B,C; columns: parts 1..10)
array[MACHINES, PARTS] of int: unitCost = array2d(MACHINES, PARTS, [
  10,  20,  30,  40,  50,  60,  70,  80,  90, 100,   % A
  15,  25,  35,  45,  55,  65,  75,  85,  95, 105,   % B
  20,  30,  40,  50,  60,  70,  80,  90, 100, 110    % C
]);

% One-time setup costs if a machine is used
array[MACHINES] of int: setupCost = [100, 135, 200];  % d_A, d_B, d_C

int: maxTypesOnC = 3;                    % at most 3 part types on machine C


% Variables
array[MACHINES, PARTS] of var 0..1: x;   % x[m,p]=1 if part p processed on machine m
array[MACHINES] of var 0..1: y;          % y[m]=1 if machine m is used (setup incurred)
var int: totalCost;                      % total cost (unit processing + setups)


% Constraints

% Each part is processed on exactly one machine
constraint
  forall(p in PARTS)(
    sum(m in MACHINES)(x[m,p]) = 1
  );

% Linking: assignments imply machine is used (setup incurred if any assigned)
constraint
  forall(m in MACHINES, p in PARTS)(
    x[m,p] <= y[m]
  );

% Conditional rule between part 1 and part 2:
% If part1 on A => part2 on B or C
constraint x[A,1] <= x[B,2] + x[C,2];
% If part1 on B or C => part2 on A
constraint x[B,1] + x[C,1] <= x[A,2];

% Fixed assignments: part 3 on A, part 4 on B, part 5 on C
constraint x[A,3] = 1;
constraint x[B,4] = 1;
constraint x[C,5] = 1;

% At most maxTypesOnC part types processed on machine C
constraint
  sum(p in PARTS)(x[C,p]) <= maxTypesOnC;

% Total cost = unit processing costs + setup costs
constraint
  totalCost =
      sum(m in MACHINES, p in PARTS)(unitCost[m,p] * x[m,p])
    + sum(m in MACHINES)(setupCost[m] * y[m]);


% Objective
solve minimize totalCost;