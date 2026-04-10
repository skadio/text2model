% Parameters
% Unit transportation costs for each cargo type (x1..x4)
array[1..4] of int: cost = [4, 3, 5, 7];

% Upper bounds for each cargo type (x1..x4); lower bounds are 0
array[1..4] of int: ub = [700, 600, 400, 500];

% Capacity limits
int: cap12 = 1000;  % x1 + x2 <= 1000
int: cap34 = 800;   % x3 + x4 <= 800

% Minimum demand requirements
int: dem13 = 500;   % x1 + x3 >= 500
int: dem24 = 600;   % x2 + x4 >= 600


% Variables
% Shipped units of each cargo type (integers)
array[1..4] of var 0..max(ub): x;

% Total transportation cost (nonnegative integer)
var 0..intmax: total_cost;


% Constraints
%---------------------------
% Bounds on shipped units (redundant with var domain, but kept for clarity)
%---------------------------
constraint
  forall(i in 1..4) (
    x[i] <= ub[i]
  );

%---------------------------
% Ship capacity constraints
%---------------------------
constraint x[1] + x[2] <= cap12;
constraint x[3] + x[4] <= cap34;

%---------------------------
% Minimum demand constraints
%---------------------------
constraint x[1] + x[3] >= dem13;
constraint x[2] + x[4] >= dem24;

%---------------------------
% Total cost definition
%---------------------------
constraint
  total_cost = sum(i in 1..4) (cost[i] * x[i]);


% Objective
solve minimize total_cost;

output [
  "x1=", show(x[1]), "\n",
  "x2=", show(x[2]), "\n",
  "x3=", show(x[3]), "\n",
  "x4=", show(x[4]), "\n",
  "total_cost=", show(total_cost), "\n"
];