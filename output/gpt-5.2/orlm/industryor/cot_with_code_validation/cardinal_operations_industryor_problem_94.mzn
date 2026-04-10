% Parameters
int: W = 4;
set of int: Weeks = 1..W;

array[Weeks] of int: demand = [15, 25, 35, 25];          % in 1000 boxes
array[Weeks] of int: capacity = [30, 40, 45, 20];        % in 1000 boxes
array[Weeks] of float: prod_cost = [5.0, 5.1, 5.4, 5.5]; % in 1000 yuan per 1000 boxes
float: hold_cost = 0.2;                                 % in 1000 yuan per week per 1000 boxes

int: total_demand = sum(w in Weeks)(demand[w]);
int: total_cap = sum(w in Weeks)(capacity[w]);

% Variables
array[Weeks] of var 0..total_cap: prod;     % production in week w (1000 boxes)
array[Weeks] of var 0..total_cap: inv;      % end-of-week inventory (1000 boxes)
var float: total_cost;

% Constraints
constraint forall(w in Weeks) (prod[w] <= capacity[w]);

constraint inv[1] = prod[1] - demand[1];
constraint forall(w in 2..W) (
  inv[w] = inv[w-1] + prod[w] - demand[w]
);

constraint forall(w in Weeks) (inv[w] >= 0);

% Objective
constraint total_cost =
  sum(w in Weeks)(prod_cost[w] * int2float(prod[w])) +
  sum(w in 1..W-1)(hold_cost * int2float(inv[w]));

solve minimize total_cost;