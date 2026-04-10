% Parameters (with values embedded)
int: N = 4;
set of int: Cities = 1..N;

array[Cities, Cities] of int: cost =
  [|  0, 76, 17, 24
   | 76,  0, 84, 11
   | 17, 84,  0, 90
   | 24, 11, 90,  0 |];

% Variables
array[Cities] of var Cities: succ;    % successor city (a permutation)
array[Cities] of var 1..N: pos;       % position in the tour (MTZ)
var int: total_cost;

% Constraints
constraint all_different(succ);

% No self-loops
constraint forall(i in Cities)(succ[i] != i);

% Miller-Tucker-Zemlin subtour elimination (anchor at city 1)
constraint pos[1] = 1;
constraint forall(i in 2..N)(pos[i] >= 2 /\ pos[i] <= N);

constraint forall(i in 2..N, j in 2..N where i != j)(
  pos[i] - pos[j] + N * bool2int(succ[i] == j) <= N - 1
);

% Total cost of the circuit
constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;