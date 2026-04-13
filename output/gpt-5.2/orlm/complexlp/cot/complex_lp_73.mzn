% Parameters (with values embedded)
int: n = 5;
set of int: Cities = 1..n;

% City mapping: 1=E, 2=F, 3=G, 4=H, 5=I
array[Cities, Cities] of int: cost =
  [|   0,  37,  72,  66,  33
   |  37,   0,  26,  56, 100
   |  72,  26,   0,  49,  32
   |  66,  56,  49,   0,  13
   |  33, 100,  32,  13,   0 |];

% Variables
array[Cities] of var Cities: succ;          % successor city in the tour
array[Cities] of var 1..n: order;           % MTZ ordering variables
var int: total_cost;

% Constraints
constraint circuit(succ);

% MTZ subtour elimination (redundant with circuit for n=5, but kept explicit)
constraint order[1] = 1;
constraint forall(i in 2..n)(order[i] >= 2 /\ order[i] <= n);
constraint forall(i in Cities, j in Cities where i != j /\ i != 1 /\ j != 1)(
  order[i] - order[j] + n * (if succ[i] == j then 1 else 0 endif) <= n - 1
);

% Total cost of the tour
constraint total_cost = sum(i in Cities)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;