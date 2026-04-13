% Resource allocation between programs X and Y (integer units)

var 0..1000: x; % units allocated to program X
var 0..1000: y; % units allocated to program Y

% Constraints
constraint 2*x + y >= 10;     % minimum overall educational impact
constraint x + 3*y <= 30;     % budgetary constraint

% Objective: minimize total benefit score
var int: total_benefit = 4*x + 3*y;
solve minimize total_benefit;

output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "minimum_total_benefit = ", show(total_benefit), "\n"
];