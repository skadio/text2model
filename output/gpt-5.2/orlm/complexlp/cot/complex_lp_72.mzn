% Parameters (with values embedded)
int: n = 5;
set of int: Cities = 1..n;

array[Cities, Cities] of int: cost =
 [|  0, 58, 15, 75, 91
  | 58,  0, 54, 85, 11
  | 15, 54,  0, 28, 61
  | 75, 85, 28,  0, 47
  | 91, 11, 61, 47,  0 |];

% Variables
array[Cities] of var Cities: succ;      % successor city in the tour
array[Cities] of var Cities: pred;      % predecessor city in the tour
array[Cities] of var 1..n: pos;         % position/order in the tour (for MTZ subtour elimination)
var int: total_cost;

% Constraints
constraint circuit(succ);
constraint inverse(succ, pred);

% MTZ-style subtour elimination (fix city 1 as anchor to break symmetry)
constraint pos[1] = 1;
constraint forall(i in 2..n)(pos[i] >= 2 /\ pos[i] <= n);

constraint forall(i in 2..n)(
  let { var int: s = succ[i] } in
    (s = 1) \/ (pos[s] = pos[i] + 1)
);

% Total cost of the Hamiltonian cycle
constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;

output [
  "Minimum total travel cost = ", show(total_cost), "\n",
  "Successor array (city -> next city): ", show(succ), "\n"
];