% Parameters (with values embedded)
int: N = 5;
set of int: CITIES = 1..N; % 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost =
 [|  0, 35, 90, 23, 62
  | 35,  0, 53, 58, 46
  | 90, 53,  0, 28, 91
  | 23, 58, 28,  0, 77
  | 62, 46, 91, 77,  0 |];

% Variables
array[CITIES] of var CITIES: succ;                 % successor city in the tour
array[CITIES] of var 0..N-1: order;                % MTZ order variables (0 for start)
var int: total_cost;

% Constraints
constraint circuit(succ);

% MTZ subtour elimination adapted to allow any start:
% Choose one node as "start" implicitly by allowing exactly one node to have order=0,
% and all others to have order in 1..N-1, consistent with successors.
constraint count(i in CITIES)(order[i] = 0) = 1;
constraint forall(i in CITIES)(
  (order[i] = 0) \/ (order[i] >= 1)
);

% Link order along arcs, skipping the (unknown) start node:
constraint forall(i in CITIES)(
  (order[i] = 0) \/ (order[succ[i]] = 0) \/
  (order[succ[i]] = order[i] + 1)
);

% Total cost
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;