% Parameters (with values embedded)
int: n = 4;
set of int: Cities = 1..n; % 1=A, 2=B, 3=C, 4=D

array[Cities, Cities] of int: cost =
  [| 0, 61, 65, 63
   | 61, 0, 94, 31
   | 65, 94, 0, 19
   | 63, 31, 19, 0 |];

% Variables
array[Cities] of var Cities: succ;           % successor city in the tour
array[Cities] of var 1..n: order;            % MTZ ordering variables
var int: total_cost;

% Constraints
constraint
  circuit(succ);

% MTZ subtour elimination
constraint
  forall(i in 2..n) (order[i] >= 2 /\ order[i] <= n);
constraint
  order[1] = 1;

constraint
  forall(i in 2..n, j in 2..n where i != j) (
    order[i] - order[j] + n * (if succ[i] == j then 1 else 0 endif) <= n - 1
  );

% Total cost
constraint
  total_cost = sum(i in Cities)( cost[i, succ[i]] );

% Objective
solve minimize total_cost;