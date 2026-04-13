% Parameters
int: nProjects = 4;                          % number of projects
set of int: PROJECTS = 1..nProjects;         % project index set

array[PROJECTS] of int: costPerUnit =        % cost per unit resource for each project
  [50, 75, 100, 125];

int: cap12 = 5000;                           % maximum resources for x1 + x2
int: cap34 = 3000;                           % maximum resources for x3 + x4
int: min13 = 2000;                           % minimum resources for x1 + x3
int: min24 = 4000;                           % minimum resources for x2 + x4

% Variables
array[PROJECTS] of var 0..max(cap12, cap34, min13, min24): x;
% x[p] = integer resources allocated to project p (x[1]=x1, ..., x[4]=x4)

var 0..(cap12*max(costPerUnit) + cap34*max(costPerUnit)): totalCost;
% totalCost = total cost implied by the allocation (bounded for linear safety)

% Constraints

% Link totalCost to the linear cost of allocations
constraint
  totalCost = sum(p in PROJECTS)(costPerUnit[p] * x[p]);

% Budget/resource caps for project groups (x1+x2 and x3+x4)
constraint
  x[1] + x[2] <= cap12;

constraint
  x[3] + x[4] <= cap34;

% Minimum quality/service requirements across specific pairs (x1+x3 and x2+x4)
constraint
  x[1] + x[3] >= min13;

constraint
  x[2] + x[4] >= min24;

% Objective
solve minimize totalCost;