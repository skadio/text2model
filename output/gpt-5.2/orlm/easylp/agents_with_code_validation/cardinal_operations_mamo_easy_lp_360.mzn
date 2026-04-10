% Parameters
% Number of projects
int: n_projects = 4;

% Cost per unit resource for each project (x1..x4)
array[1..n_projects] of int: cost = [50, 75, 100, 125];

% Upper bounds on grouped allocations
int: max_x1_x2 = 5000;   % x1 + x2 <= 5000
int: max_x3_x4 = 3000;   % x3 + x4 <= 3000

% Lower bounds on paired allocations
int: min_x1_x3 = 2000;   % x1 + x3 >= 2000
int: min_x2_x4 = 4000;   % x2 + x4 >= 4000


% Variables
% Integer resource allocation to each project (nonnegative, bounded for finiteness)
var 0..max_x1_x2: x1;  % project 1 allocation
var 0..max_x1_x2: x2;  % project 2 allocation
var 0..max_x3_x4: x3;  % project 3 allocation
var 0..max_x3_x4: x4;  % project 4 allocation

% Total cost to be minimized
var 0..(cost[1]*max_x1_x2 + cost[2]*max_x1_x2 + cost[3]*max_x3_x4 + cost[4]*max_x3_x4): total_cost;


% Constraints
% Link total_cost to the weighted sum of project allocations
constraint
  total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;

% Budget / capacity caps on grouped allocations
constraint
  x1 + x2 <= max_x1_x2;

constraint
  x3 + x4 <= max_x3_x4;

% Minimum quality / coverage requirements on paired allocations
constraint
  x1 + x3 >= min_x1_x3;

constraint
  x2 + x4 >= min_x2_x4;


% Objective
solve minimize total_cost;