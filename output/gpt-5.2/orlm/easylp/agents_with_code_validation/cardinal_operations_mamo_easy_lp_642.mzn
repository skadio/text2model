% Parameters
int: nProjects = 4;                          % Number of projects
set of int: PROJECTS = 1..nProjects;         % Project index set

array[PROJECTS] of int: cost = [4, 3, 5, 6]; % Unit costs for x1..x4

int: maxX1 = 300;                            % Upper bound for x1
int: maxX2 = 500;                            % Upper bound for x2
int: maxX3 = 2000;                           % Upper bound for x3
int: maxX4 = 30;                             % Upper bound for x4

int: cap12 = 1000;                           % Constraint: x1 + x2 <= 1000
int: req13 = 2000;                           % Constraint: 2*x1 + 3*x3 >= 2000
int: diff24 = 500;                           % Constraint: x2 - 0.5*x4 <= 500
int: diff123 = 70;                           % Constraint: x1 - (x2 + x3) <= 70


% Variables
var 0..maxX1: x1;                            % Resource allocation to project 1 (integer)
var 0..maxX2: x2;                            % Resource allocation to project 2 (integer)
var 0..maxX3: x3;                            % Resource allocation to project 3 (integer)
var 0..maxX4: x4;                            % Resource allocation to project 4 (integer)

array[PROJECTS] of var int: x;               % Convenience array for x1..x4

var 0..(4*maxX1 + 3*maxX2 + 5*maxX3 + 6*maxX4): totalCost;  % Objective value (bounded)


% Constraints
% Link scalar decision variables into the convenience array
constraint x[1] = x1;
constraint x[2] = x2;
constraint x[3] = x3;
constraint x[4] = x4;

% --- Budget / capacity constraint for projects 1 and 2
constraint x1 + x2 <= cap12;

% --- Minimum requirement involving projects 1 and 3
constraint 2 * x1 + 3 * x3 >= req13;

% --- Difference constraint between x2 and half of x4 (kept integral by scaling by 2)
constraint 2 * x2 - x4 <= 2 * diff24;

% --- Difference constraint between x1 and (x2 + x3)
constraint x1 - (x2 + x3) <= diff123;

% --- Total cost definition (linear aggregation using the convenience array)
constraint totalCost = sum(i in PROJECTS)(cost[i] * x[i]);


% Objective
solve minimize totalCost;