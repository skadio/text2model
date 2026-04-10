% Resource allocation for environmental projects X and Y

var int: x; % allocation to project X
var int: y; % allocation to project Y

% Constraints
constraint 4*x + 5*y <= 100;          % budget limitation in weighted units
constraint x + y >= 20;               % minimum combined allocation
constraint abs(2*x - y) <= 30;        % balance constraint
constraint x >= 0 /\ y >= 0;          % nonnegativity
constraint x <= 100 /\ y <= 100;      % safe upper bounds

% Objective: minimize total cost
var int: total_cost = 6*x + 2*y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];