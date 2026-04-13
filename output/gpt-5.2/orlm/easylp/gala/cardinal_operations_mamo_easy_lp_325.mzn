% Real estate investment minimization (all data embedded)

% Decision variables: whole-number units invested in each property type
var 0..50: x;  % residential
var 0..50: y;  % commercial
var 0..50: z;  % industrial

% Constraints
constraint x + y + z <= 50;        % total budget
constraint 2*x + y >= 30;          % diversification requirement
constraint y + z <= 20;            % regulatory/risk cap

% Objective: minimize total return
var int: return = 100*x + 200*y + 300*z;
solve minimize return;

output [
  "x(residential) = ", show(x), "\n",
  "y(commercial)  = ", show(y), "\n",
  "z(industrial)  = ", show(z), "\n",
  "Return($)      = ", show(return), "\n"
];