include "globals.mzn";

% ----------------------------
% Data (embedded from statement)
% ----------------------------
int: T = 5; % goods types: 1..5 = A,B,C,D,E
set of int: Goods = 1..T;

int: A = 1; int: B = 2; int: C = 3; int: D = 4; int: E = 5;

array[Goods] of int: demand = [120, 90, 300, 90, 120];          % units
array[Goods] of int: w_num  = [50, 100, 40, 60, 65];            % weight*100 (tons*100)
int: w_den = 100;

int: cap_num = 6000;   % 60 tons * 100
int: minload_num = 1800; % 18 tons * 100

int: minD = 12;        % each used container must load at least 12 units of D

% Upper bound on containers: each container must carry at least 12 D if used, total D=90
int: N = demand[D] div minD; % = 7 (since 7*12=84, cannot have 8 used containers)

set of int: Cont = 1..N;

% ----------------------------
% Decision variables
% ----------------------------
array[Cont, Goods] of var 0..max(demand): x;  % units of each good in each container
array[Cont] of var 0..1: used;               % 1 if container used, else 0

% Weights per container (scaled by 100)
array[Cont] of var 0..cap_num: load_num;

% ----------------------------
% Constraints
% ----------------------------

% Demand satisfaction (exactly ship all units)
constraint forall(g in Goods)(
  sum(c in Cont)(x[c,g]) = demand[g]
);

% Compute load in each container and enforce capacity / minimum load if used
constraint forall(c in Cont)(
  load_num[c] = sum(g in Goods)(w_num[g] * x[c,g])
);

constraint forall(c in Cont)(
  load_num[c] <= cap_num * used[c]
);

constraint forall(c in Cont)(
  load_num[c] >= minload_num * used[c]
);

% Link used with having any items (if used then at least one unit shipped; if not used then no items)
constraint forall(c in Cont)(
  sum(g in Goods)(x[c,g]) >= used[c]
);
constraint forall(c in Cont, g in Goods)(
  x[c,g] <= demand[g] * used[c]
);

% Packaging requirement: if any A is loaded in a container, then at least 1 unit of C in that container
constraint forall(c in Cont)(
  x[c,A] > 0 -> x[c,C] >= 1
);

% Each used container must load at least 12 units of D
constraint forall(c in Cont)(
  x[c,D] >= minD * used[c]
);

% Symmetry breaking: use containers from 1..k in order (no gaps)
constraint forall(c in 1..N-1)(
  used[c] >= used[c+1]
);

% Optional stronger symmetry breaking: non-increasing loads
constraint forall(c in 1..N-1)(
  load_num[c] >= load_num[c+1]
);

% ----------------------------
% Objective
% ----------------------------
var 0..N: numUsed = sum(c in Cont)(used[c]);
solve minimize numUsed;

% ----------------------------
% Output
% ----------------------------
output [
  "Minimum containers used = ", show(numUsed), "\n",
  "Used = ", show(used), "\n\n",
  "Per-container plan (A,B,C,D,E) and load (tons):\n"
] ++
[
  if fix(used[c]) = 1 then
    "Container " ++ show(c) ++ ": " ++
    "A=" ++ show(x[c,A]) ++ " " ++
    "B=" ++ show(x[c,B]) ++ " " ++
    "C=" ++ show(x[c,C]) ++ " " ++
    "D=" ++ show(x[c,D]) ++ " " ++
    "E=" ++ show(x[c,E]) ++
    " | load=" ++ show(load_num[c] div 100) ++ "." ++
      (if (load_num[c] mod 100) < 10 then "0" else "" endif) ++ show(load_num[c] mod 100) ++ " tons\n"
  else
    ""
  endif
  | c in Cont
];