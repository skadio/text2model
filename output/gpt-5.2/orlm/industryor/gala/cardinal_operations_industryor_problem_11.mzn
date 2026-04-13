include "globals.mzn";

% Red Star Plastics Factory - Production with substitution (larger volume can satisfy smaller demand)

int: n = 6;
set of int: T = 1..n;

array[T] of int: volume = [1500, 2500, 4000, 6000, 9000, 12000];
array[T] of int: demand = [500, 550, 700, 900, 400, 300];
array[T] of int: varCost = [5, 8, 10, 12, 16, 18];

int: setupCost = 1200;

% Decision variables
% p[i] = produced quantity of type i
array[T] of var 0..sum(demand): p;

% use[i,j] = how many units of produced type i are used to satisfy demand of type j
% Feasible only if i has volume >= j (here codes are sorted by increasing volume => i >= j)
array[T, T] of var 0..sum(demand): use;

% act[i] = 1 iff equipment for type i is activated (p[i] > 0)
array[T] of var 0..1: act;

% Enforce substitution feasibility and flow conservation
constraint
  forall(j in T) (
    sum(i in j..n)(use[i,j]) = demand[j]     % meet each demand j using types i >= j
  );

constraint
  forall(i in T) (
    sum(j in 1..i)(use[i,j]) <= p[i]         % produced units can be allocated to demands of <= its index
  );

constraint
  forall(i in T, j in T where i < j) (
    use[i,j] = 0                             % disallow using smaller types to meet larger demand
  );

% Activation linking (big-M)
int: M = sum(demand);
constraint forall(i in T) (
  p[i] <= M * act[i] /\ p[i] >= act[i]
);

% Objective: variable production + fixed setups
var int: totalVarCost = sum(i in T)(varCost[i] * p[i]);
var int: totalSetupCost = setupCost * sum(i in T)(act[i]);
var int: totalCost = totalVarCost + totalSetupCost;

solve minimize totalCost;

output [
  "Total cost = ", show(totalCost), "\n",
  "  Variable cost = ", show(totalVarCost), "\n",
  "  Setup cost = ", show(totalSetupCost), "\n\n",
  "Produced quantities p[1..6] = ", show(p), "\n",
  "Activated act[1..6] = ", show(act), "\n\n",
  "Allocation use[i,j] (i supplies j; only i>=j can be >0):\n",
  concat([ concat([ if i>=j then
                      "use[" ++ show(i) ++ "," ++ show(j) ++ "]=" ++ show(use[i,j]) ++ "  "
                    else "" endif
                  | i in T ]) ++ "\n"
         | j in T ])
];