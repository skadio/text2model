% Parameters
int: W = 4;                               % number of weeks
set of int: Weeks = 1..W;                 % week index set

array[Weeks] of int: demand   = [15, 25, 35, 25];        % demand (1000 boxes) per week
array[Weeks] of int: capacity = [30, 40, 45, 20];        % production capacity (1000 boxes) per week
array[Weeks] of float: prod_cost = [5.0, 5.1, 5.4, 5.5]; % production cost (1000 yuan per 1000 boxes)

float: hold_cost = 0.2;                   % storage cost (1000 yuan per 1000 boxes per week)

% Variables
array[Weeks] of var 0..max(capacity): prod;      % production quantity (1000 boxes) per week
array[0..W] of var 0..sum(capacity): inv;        % end-of-week inventory (1000 boxes), inv[0] initial

% Constraints
constraint inv[0] = 0;                                     % zero initial inventory
constraint forall(t in Weeks)(prod[t] <= capacity[t]);     % per-week capacity

% Inventory balance (flow conservation) and demand satisfaction:
% End inventory each week = previous inventory + production - demand.
constraint
  forall(t in Weeks) (
    inv[t] = inv[t-1] + prod[t] - demand[t]
  );

% Feasibility reinforcement: cumulative production must cover cumulative demand.
constraint
  forall(t in Weeks) (
    sum(i in 1..t)(prod[i]) >= sum(i in 1..t)(demand[i])
  );

% Objective
solve minimize
  sum(t in Weeks)(prod_cost[t] * prod[t])
  + sum(t in 1..W-1)(hold_cost * inv[t]);