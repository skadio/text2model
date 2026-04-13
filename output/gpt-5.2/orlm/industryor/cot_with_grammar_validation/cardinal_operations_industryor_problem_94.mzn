% Parameters
int: W = 4;
set of int: Weeks = 1..W;

array[Weeks] of int: demand = [15, 25, 35, 25];              % in 1000 boxes
array[Weeks] of int: capacity = [30, 40, 45, 20];            % in 1000 boxes
array[Weeks] of float: prod_cost = [5.0, 5.1, 5.4, 5.5];     % in 1000 yuan per 1000 boxes
float: hold_cost = 0.2;                                      % in 1000 yuan per 1000 boxes per week

int: total_demand = sum(w in Weeks)(demand[w]);

% Variables
array[Weeks] of var 0..max(capacity): prod;                  % production in 1000 boxes
array[0..W] of var 0..total_demand: inv;                     % end-of-week inventory in 1000 boxes (inv[0] initial)

% Constraints
constraint inv[0] = 0;

constraint forall(w in Weeks)(
  prod[w] <= capacity[w]
);

constraint forall(w in Weeks)(
  inv[w] = inv[w-1] + prod[w] - demand[w]
);

constraint forall(w in Weeks)(
  inv[w] >= 0
);

% Objective
var float: total_cost =
  sum(w in Weeks)(prod_cost[w] * int2float(prod[w])) +
  sum(w in Weeks)(hold_cost * int2float(inv[w]));

solve minimize total_cost;