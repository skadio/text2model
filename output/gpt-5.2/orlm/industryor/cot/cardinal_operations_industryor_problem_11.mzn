% Parameters (with values embedded)
int: N = 6;
set of int: T = 1..N;

array[T] of int: volume = [1500, 2500, 4000, 6000, 9000, 12000];
array[T] of int: demand = [500, 550, 700, 900, 400, 300];
array[T] of int: varCost = [5, 8, 10, 12, 16, 18];

int: setupCost = 1200;

% Feasible substitution: type i can satisfy demand of type j iff volume[i] >= volume[j]
% Given types are sorted by volume, this is equivalent to i >= j.
array[T,T] of bool: canSub = array2d(T, T,
[
 true,  true,  true,  true,  true,  true,
 false, true,  true,  true,  true,  true,
 false, false, true,  true,  true,  true,
 false, false, false, true,  true,  true,
 false, false, false, false, true,  true,
 false, false, false, false, false, true
]);

int: totalDemand = sum(t in T)(demand[t]);

% Variables
array[T] of var 0..totalDemand: produce;          % units produced of each type
array[T] of var bool: activate;                   % whether equipment is activated
array[T,T] of var 0..totalDemand: assign;         % assign[i,j] = units of type i used to satisfy demand of type j

% Constraints
% Demand satisfaction: each demand type j must be fully met by admissible substitutes i
constraint
  forall(j in T)(
    sum(i in T where canSub[i,j]) (assign[i,j]) = demand[j]
  );

% Flow conservation: each produced unit of type i must be assigned to some demand j it can satisfy
constraint
  forall(i in T)(
    sum(j in T where canSub[i,j]) (assign[i,j]) = produce[i]
  );

% Activation linking: if produce[i] > 0 then activate[i] = true; if activate[i] = false then produce[i] = 0
constraint
  forall(i in T)(
    produce[i] <= totalDemand * bool2int(activate[i])
  );

% Objective
var int: totalCost =
  sum(i in T)(varCost[i] * produce[i]) +
  sum(i in T)(setupCost * bool2int(activate[i]));

solve minimize totalCost;