% Parameters (with values embedded)
int: N = 10;
set of int: Parts = 1..N;

set of int: Machines = 1..3;
int: A = 1;
int: B = 2;
int: C = 3;

array[Machines, Parts] of int: unitCost =
  array2d(Machines, Parts,
  [
    10, 20, 30, 40, 50, 60, 70, 80, 90, 100,   % A
    15, 25, 35, 45, 55, 65, 75, 85, 95, 105,   % B
    20, 30, 40, 50, 60, 70, 80, 90, 100, 110   % C
  ]);

array[Machines] of int: setupCost = [100, 135, 200];

% Variables
array[Machines, Parts] of var 0..1: x;         % x[m,p]=1 if part p processed on machine m
array[Machines] of var 0..1: y;                % y[m]=1 if machine m is used (any part assigned)

% Constraints
% Each part processed on exactly one machine
constraint forall(p in Parts)(
  sum(m in Machines)(x[m,p]) = 1
);

% Link setup to usage (if any part assigned to a machine, pay setup once)
constraint forall(m in Machines, p in Parts)(
  x[m,p] <= y[m]
);

% Part 1 / Part 2 logical constraint
% If part1 on A then part2 on B or C; else (part1 on B or C) then part2 on A
constraint (x[A,1] = x[B,2] + x[C,2]);
% (This single equation enforces both directions given each part assigned exactly once.)

% Fixed assignments: part 3 on A, part 4 on B, part 5 on C
constraint x[A,3] = 1;
constraint x[B,4] = 1;
constraint x[C,5] = 1;

% At most 3 types of parts processed on machine C
constraint sum(p in Parts)(x[C,p]) <= 3;

% Objective
var int: totalCost =
  sum(m in Machines, p in Parts)(unitCost[m,p] * x[m,p]) +
  sum(m in Machines)(setupCost[m] * y[m]);

solve minimize totalCost;