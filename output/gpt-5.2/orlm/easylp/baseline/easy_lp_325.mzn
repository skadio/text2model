% Real estate investment minimization (returns)
% Variables: x=residential, y=commercial, z=industrial (integer units)

var 0..50: x;
var 0..50: y;
var 0..50: z;

% Constraints
constraint x + y + z <= 50;        % total investment budget
constraint 2*x + y >= 30;          % diversification requirement
constraint y + z <= 20;            % regulatory/risk cap

% Objective: minimize total return
var int: total_return = 100*x + 200*y + 300*z;

solve minimize total_return;

output [
  "x=", show(x), " y=", show(y), " z=", show(z), "\n",
  "min_return=$", show(total_return), "\n"
];