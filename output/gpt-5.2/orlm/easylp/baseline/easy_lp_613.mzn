% Crop planting cost minimization with resource/land constraints
% All data embedded; acres are whole numbers.

int: n = 4;
set of int: CROPS = 1..n;

array[CROPS] of int: cost = [5, 3, 7, 6];          % cost per acre for x1..x4
array[CROPS] of int: maxA = [100, 200, 150, 120];  % land upper bounds

% Decision variables: acres planted of each crop
array[CROPS] of var 0..maxA[CROPS]: x;

% Constraints (interpreting "resources used" as acres allocated)
constraint 2*x[1] + 3*x[2] <= 50;            % fertilizer
constraint 4*x[1] + x[3] <= 40;              % water
constraint 5*x[4] >= x[2] + 10;              % soil requirement
constraint (x[1] + x[2]) - (x[3] + x[4]) = 0; % ecological balance

% Objective: minimum total cost
var int: total_cost = sum(i in CROPS)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "min_cost=", show(total_cost), "\n"
];