% Parameters
int: N = 5;
set of int: CITIES = 1..N; % 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost =
  [|  0, 64, 78, 23, 15
   | 64,  0, 15, 44, 93
   | 78, 15,  0, 53, 57
   | 23, 44, 53,  0, 56
   | 15, 93, 57, 56,  0 |];

% Variables
array[CITIES] of var CITIES: succ;      % successor city for each city
array[CITIES] of var 0..N: order;       % MTZ ordering to eliminate subtours
var 0..sum(i in CITIES, j in CITIES)(cost[i,j]): total_cost;

% Constraints
constraint
  forall(i in CITIES)(succ[i] != i);

constraint
  forall(j in CITIES)(count(i in CITIES)(succ[i] = j) = 1);

constraint
  order[1] = 1 /\
  forall(i in CITIES where i != 1)(order[i] >= 2 /\ order[i] <= N);

constraint
  forall(i in CITIES where i != 1)(
    forall(j in CITIES where j != 1 /\ j != i)(
      order[i] - order[j] + N * (if succ[i] = j then 1 else 0 endif) <= N - 1
    )
  );

constraint
  total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;