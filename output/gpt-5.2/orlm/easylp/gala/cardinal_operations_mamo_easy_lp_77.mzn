% Construction manpower allocation (integer linear optimization)
% Embed all data directly (no .dzn needed).

int: max_limit = 120;   % 2*X + 3*Y <= 120
int: min_total = 40;    % X + Y >= 40
int: costX = 50;        % $ per hour on X
int: costY = 30;        % $ per hour on Y

% Decision variables: whole hours allocated to tasks X and Y
var 0..max_limit: X;
var 0..max_limit: Y;

% Constraints
constraint 2*X + 3*Y <= max_limit;
constraint X + Y >= min_total;

% Objective: minimize total cost
var int: total_cost = costX*X + costY*Y;

solve minimize total_cost;

output [
  "X = ", show(X), " hours\n",
  "Y = ", show(Y), " hours\n",
  "Minimum total cost (rounded) = $", show(total_cost), "\n"
];