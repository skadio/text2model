% Parameters
% Number of locations
int: nLoc = 4;

% Index set of locations (1=X1, 2=X2, 3=X3, 4=X4)
set of int: LOC = 1..nLoc;

% Cost per vehicle at each location (X1..X4)
array[LOC] of int: cost = [2, 3, 4, 5];

% Upper bounds (max vehicles) at each location (X1..X4)
array[LOC] of int: ub = [300, 200, 300, 400];

% Group capacity constraints
int: cap12 = 500;   % X1 + X2 <= 500
int: cap34 = 600;   % X3 + X4 <= 600

% Minimum service constraints
int: min13 = 300;   % X1 + X3 >= 300
int: min24 = 400;   % X2 + X4 >= 400


% Variables
% Vehicles allocated to each location (must be whole numbers)
array[LOC] of var 0..max(ub): x;

% Total cost (bounded for linear objective usage)
var 0..(sum(i in LOC)(ub[i] * cost[i])): total_cost;


% Constraints
% Link total_cost to the allocation decisions
constraint
  total_cost = sum(i in LOC)(x[i] * cost[i]);

% Individual upper bound constraints for each location
constraint
  forall(i in LOC) (
    x[i] <= ub[i]
  );

% Group capacity constraints (operational caps)
constraint
  x[1] + x[2] <= cap12;

constraint
  x[3] + x[4] <= cap34;

% Minimum service level constraints (coverage requirements)
constraint
  x[1] + x[3] >= min13;

constraint
  x[2] + x[4] >= min24;


% Objective
solve minimize total_cost;