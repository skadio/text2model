% Task scheduling cost minimization (all data embedded)

int: max_hours = 24;

array[1..4] of int: cost_per_hour = [3, 4, 5, 6]; % X1..X4

% Decision variables: whole hours for each task
array[1..4] of var 0..max_hours: X; % X[1]=X1, X[2]=X2, X[3]=X3, X[4]=X4

% Constraints
constraint X[1] + X[2] >= 10;
constraint X[2] + X[3] <= 20;
constraint X[1] >= X[4] + 5;
constraint X[3] <= X[4] + 10;

% Objective: minimize total cost
var int: total_cost = sum(i in 1..4)(cost_per_hour[i] * X[i]);
solve minimize total_cost;

output [
  "X1=", show(X[1]), " X2=", show(X[2]), " X3=", show(X[3]), " X4=", show(X[4]), "\n",
  "Minimum total cost ($): ", show(total_cost), "\n"
];