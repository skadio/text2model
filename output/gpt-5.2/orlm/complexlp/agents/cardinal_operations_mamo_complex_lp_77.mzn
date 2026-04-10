% Parameters
int: nCities = 4;                          % Number of cities
set of int: CITIES = 1..nCities;           % City indices

array[CITIES, CITIES] of int: cost =       % Travel cost matrix (cost[i,j])
  [|  0, 27, 48, 76
   | 27,  0, 82, 88
   | 48, 82,  0, 97
   | 76, 88, 97,  0 |];

int: minCost = 0;                          % Lower bound on costs (kept for completeness)
int: maxCost = max([cost[i,j] | i in CITIES, j in CITIES]);  % Upper bound on single leg cost

% Variables
array[CITIES] of var CITIES: succ;         % succ[i] = next city visited after i
array[CITIES] of var CITIES: pred;         % pred[i] = previous city visited before i

array[CITIES] of var 0..(nCities*maxCost): u; % MTZ ordering variables (subtour elimination)
var 0..(nCities*maxCost): totalCost;       % Total tour cost

% Constraints

% -------------------------------------------------------------------
% Hamiltonian cycle structure: each city has exactly one successor
% and exactly one predecessor (a permutation in both directions)
% -------------------------------------------------------------------
constraint all_different(succ);
constraint all_different(pred);

% -------------------------------------------------------------------
% Successor/Predecessor consistency: pred is the inverse of succ
% (i.e., j = succ[i]  <->  i = pred[j])
% -------------------------------------------------------------------
constraint
  forall(i in CITIES) (
    pred[succ[i]] = i
  );

constraint
  forall(j in CITIES) (
    succ[pred[j]] = j
  );

% -------------------------------------------------------------------
% Subtour elimination (MTZ-style) to ensure a single tour visiting all cities
% Fix an anchor city (City 1) to break symmetry and define the order.
% u values represent visit positions.
% -------------------------------------------------------------------
constraint u[1] = 1;

constraint
  forall(i in CITIES where i != 1) (
    u[i] >= 2 /\ u[i] <= nCities
  );

% MTZ constraints: prevent subtours among non-anchor cities
% Note: (succ[i] = j) is reified via an if-then-else to avoid extra vars.
constraint
  forall(i in CITIES where i != 1) (
    forall(j in CITIES where j != 1 /\ j != i) (
      u[i] - u[j] + nCities * (if succ[i] = j then 0 else 1 endif) <= nCities - 1
    )
  );

% -------------------------------------------------------------------
% Tour cost accumulation: totalCost equals sum of costs along successor arcs
% -------------------------------------------------------------------
constraint
  totalCost = sum(i in CITIES) (cost[i, succ[i]]);

% Objective
solve minimize totalCost;