% Parameters
% Unit costs for each distribution center (embedded from problem statement)
array[1..4] of int: cost = [100, 200, 150, 250];

% Capacity limits on grouped allocations
int: cap12 = 5000;   % x1 + x2 <= 5000
int: cap34 = 6000;   % x3 + x4 <= 6000

% Minimum required allocations on specified pairs
int: min13 = 3000;   % x1 + x3 >= 3000
int: min24 = 4000;   % x2 + x4 >= 4000

% Individual upper bounds for each center
array[1..4] of int: ub = [5000, 5000, 6000, 6000];


% Variables
% Integer allocations to each center (nonnegative, bounded by individual maxima)
array[1..4] of var int: x;

% Total cost to minimize
var int: total_cost;


% Constraints
% Individual allocation bounds (nonnegative and within center-specific maxima)
constraint forall(i in 1..4) (
  x[i] >= 0 /\ x[i] <= ub[i]
);

% Group capacity constraints (budget/capacity limitations on paired centers)
constraint x[1] + x[2] <= cap12;   % x1 + x2 cannot exceed 5000
constraint x[3] + x[4] <= cap34;   % x3 + x4 cannot exceed 6000

% Minimum combined allocation requirements (service level constraints)
constraint x[1] + x[3] >= min13;   % x1 + x3 must be at least 3000
constraint x[2] + x[4] >= min24;   % x2 + x4 must be at least 4000

% Total cost calculation (link decision variables to total_cost)
constraint total_cost = sum(i in 1..4)(cost[i] * x[i]);


% Objective
solve minimize total_cost;