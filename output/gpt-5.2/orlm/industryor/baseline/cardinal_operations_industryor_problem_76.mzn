int: N = 10;
set of int: Parts = 1..N;

set of int: Machines = 1..3;
int: A = 1;
int: B = 2;
int: C = 3;

array[Machines, Parts] of int: unitCost =
[
  % Parts:  1   2   3   4   5   6   7   8   9   10
            10, 20, 30, 40, 50, 60, 70, 80, 90, 100,   % A
            15, 25, 35, 45, 55, 65, 75, 85, 95, 105,   % B
            20, 30, 40, 50, 60, 70, 80, 90, 100, 110   % C
];

array[Machines] of int: setupCost = [100, 135, 200];

% assign[p,m] = 1 iff part p is processed on machine m
array[Parts, Machines] of var 0..1: assign;

% used[m] = 1 iff any part is processed on machine m (setup cost incurred)
array[Machines] of var 0..1: used;

% Each part must be processed on exactly one machine
constraint forall(p in Parts) (
  sum(m in Machines)(assign[p,m]) = 1
);

% Link used[m] with assign
constraint forall(m in Machines, p in Parts) (
  assign[p,m] <= used[m]
);

% Conditional constraint between part 1 and part 2
% If part 1 on A then part 2 on B or C
constraint assign[1,A] -> (assign[2,B] + assign[2,C] = 1);
% If part 1 on B or C then part 2 on A
constraint (assign[1,B] + assign[1,C] = 1) -> (assign[2,A] = 1);

% Fixed assignments: part 3 on A, part 4 on B, part 5 on C
constraint assign[3,A] = 1;
constraint assign[4,B] = 1;
constraint assign[5,C] = 1;

% At most 3 types of parts processed on machine C
constraint sum(p in Parts)(assign[p,C]) <= 3;

% Objective: minimize total (unit processing + setup) cost
var int: totalCost =
  sum(p in Parts, m in Machines)(unitCost[m,p] * assign[p,m]) +
  sum(m in Machines)(setupCost[m] * used[m]);

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "Machine used: A=", show(used[A]), " B=", show(used[B]), " C=", show(used[C]), "\n",
  "Assignments (part -> machine):\n"
] ++
[
  "Part ", show(p), " -> ",
  if fix(assign[p,A]) = 1 then "A"
  elseif fix(assign[p,B]) = 1 then "B"
  else "C" endif,
  "\n"
  | p in Parts
];