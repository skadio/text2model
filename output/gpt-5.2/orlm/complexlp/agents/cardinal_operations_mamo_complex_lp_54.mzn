% Parameters
int: n_districts = 4;                                   % Number of districts
set of int: DISTRICTS = 1..n_districts;                 % District index set

array[DISTRICTS] of int: supply = [412, 92, 265, 342];  % Current food supplies per district
array[DISTRICTS] of int: demand = [74, 334, 61, 352];   % Required food per district

% Transportation cost per unit shipped from i to j (cost[i,i]=0 for completeness)
array[DISTRICTS, DISTRICTS] of int: cost =
[
  |  0, 20, 43,  1 |
  | 42,  0, 32, 13 |
  | 27,  5,  0, 10 |
  | 30, 22,  9,  0 |
];

% Variables
array[DISTRICTS, DISTRICTS] of var 0..max(supply): ship;  % Units shipped from i to j
var 0..(max(cost) * sum(supply)): total_cost;             % Total transportation cost

% Constraints
% Flow conservation per district:
% supply + inflow - outflow = demand  <=>  outflow - inflow = supply - demand
constraint
  forall(i in DISTRICTS) (
    sum(j in DISTRICTS where j != i)(ship[i, j]) -
    sum(j in DISTRICTS where j != i)(ship[j, i]) = supply[i] - demand[i]
  );

% No self-transport
constraint
  forall(i in DISTRICTS) (
    ship[i, i] = 0
  );

% Total cost definition
constraint
  total_cost =
    sum(i in DISTRICTS, j in DISTRICTS)(
      ship[i, j] * cost[i, j]
    );

% Objective
solve minimize total_cost;