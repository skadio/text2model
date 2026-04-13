% Parameters
int: W = 4;
set of int: Weeks = 1..W;

array[Weeks] of int: demand = [15, 25, 35, 25];          % 1000 boxes
array[Weeks] of int: capacity = [30, 40, 45, 20];        % 1000 boxes
array[Weeks] of float: prod_cost = [5.0, 5.1, 5.4, 5.5]; % 1000 yuan per 1000 boxes
float: hold_cost = 0.2;                                 % 1000 yuan per 1000 boxes per week

int: maxCap = max(capacity);
int: maxInv = sum(capacity); % safe upper bound on inventory

% Variables
array[Weeks] of var 0..maxCap: prod;     % production in week t (1000 boxes)
array[0..W] of var 0..maxInv: inv;       % inventory at end of week t (1000 boxes), inv[0]=initial

var float: total_cost;

% Constraints
constraint inv[0] = 0;

constraint forall(t in Weeks) (
  prod[t] <= capacity[t]
);

constraint forall(t in Weeks) (
  inv[t] = inv[t-1] + prod[t] - demand[t]
);

constraint forall(t in Weeks) (
  inv[t] >= 0
);

constraint total_cost =
  sum(t in Weeks)(prod_cost[t] * int2float(prod[t])) +
  sum(t in Weeks)(hold_cost * int2float(inv[t]));

% Objective
solve minimize total_cost;