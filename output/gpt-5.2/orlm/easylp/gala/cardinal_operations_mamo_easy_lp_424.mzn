% Manufacturing production planning (integer optimization)

% Decision variables: whole number of units produced
var 0..10000: x1;
var 0..10000: x2;

% Constraints
constraint 10*x1 + 15*x2 <= 2000;          % machine capacity
constraint 12*x1 + 6*x2 >= 800;            % minimum productivity
constraint abs(x1 - (x2 div 2)) <= 100;    % balance constraint using integer half

% Objective: minimize total cost
var int: total_cost = 50*x1 + 75*x2;

solve minimize total_cost;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "minimum_total_cost = ", show(total_cost), "\n"
];