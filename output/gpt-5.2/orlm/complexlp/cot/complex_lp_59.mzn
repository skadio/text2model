% Parameters (with values embedded)
int: n = 5;
set of int: CITIES = 1..n; % 1=E, 2=F, 3=G, 4=H, 5=I

array[CITIES, CITIES] of int: cost =
[| 0, 50, 48, 99, 91
 | 50, 0, 57, 84, 72
 | 48, 57, 0, 46, 86
 | 99, 84, 46, 0, 29
 | 91, 72, 86, 29, 0 |];

% Variables
array[CITIES] of var CITIES: succ;   % successor city in the tour
array[CITIES] of var CITIES: pred;   % predecessor city in the tour
array[CITIES] of var 0..n-1: pos;    % position/order variable for subtour elimination (MTZ)

var int: total_cost;

% Constraints
constraint forall(i in CITIES)(succ[i] != i);
constraint forall(i in CITIES)(pred[i] != i);

constraint all_different(succ);
constraint all_different(pred);

% Link pred and succ to represent a single Hamiltonian cycle
constraint forall(i in CITIES)(pred[succ[i]] = i);
constraint forall(i in CITIES)(succ[pred[i]] = i);

% MTZ subtour elimination anchored at city 1 (E)
constraint pos[1] = 0;
constraint forall(i in CITIES where i != 1)(pos[i] >= 1 /\ pos[i] <= n-1);
constraint forall(i, j in CITIES where i != j /\ i != 1 /\ j != 1)(
  pos[i] - pos[j] + (n-1) * (if succ[i] = j then 1 else 0 endif) <= n-2
);

% Total cost of the tour
constraint total_cost = sum(i in CITIES)(cost[i, succ[i]]);

% Objective
solve minimize total_cost;