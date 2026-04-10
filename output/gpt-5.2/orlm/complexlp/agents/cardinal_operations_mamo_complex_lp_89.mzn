% Parameters
int: nCities = 5;                       % Number of cities
set of int: Cities = 1..nCities;        % City index set

array[Cities, Cities] of int: cost =    % Travel cost matrix (including 0 on diagonal)
[
  |  0, 82, 76, 92, 59
  | 82,  0, 98, 58, 82
  | 76, 98,  0, 26, 74
  | 92, 58, 26,  0, 96
  | 59, 82, 74, 96,  0
];

% Variables
array[Cities] of var Cities: succ;       % succ[i] = next city visited after city i
array[Cities] of var Cities: pred;       % pred[j] = previous city visited before city j
array[Cities] of var 1..nCities: pos;    % Position/order of visiting each city in the tour
var 0..(max(cost) * nCities): totalCost; % Total tour cost (bounded using max edge cost)

% Constraints

% --- Tour structure: each city has exactly one successor and one predecessor ---
constraint all_different(succ);
constraint all_different(pred);
constraint inverse(succ, pred);

% --- Eliminate self-loops (cannot go from a city to itself) ---
constraint forall(i in Cities) (succ[i] != i);

% --- Single Hamiltonian cycle (subtour elimination) via circuit constraint ---
constraint circuit(succ);

% --- Position variables consistent with successor relation (symmetry breaking) ---
constraint pos[1] = 1;
constraint forall(i in Cities) (
  pos[succ[i]] = (pos[i] mod nCities) + 1
);

% --- Total cost accumulation of selected arcs ---
constraint totalCost = sum(i in Cities) (cost[i, succ[i]]);

% Objective
solve minimize totalCost;