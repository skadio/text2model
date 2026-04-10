% Energy investment optimization (all data embedded)

% Decision variables (integer investments)
var 0..1000: x;   % investment in project X
var 0..1000: y;   % investment in project Y

% Constraints
constraint x + y >= 30;
constraint 5*x + 3*y <= 150;

% Objective: minimize total cost
var int: total_cost = 40*x + 50*y;
solve minimize total_cost;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];