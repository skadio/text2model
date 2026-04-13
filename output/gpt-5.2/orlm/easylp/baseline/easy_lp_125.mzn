% Extra classes planning: minimize total cost
% Subjects: Math (X) and Science (Y)

var 0..1000: X; % number of Math classes (integer)
var 0..1000: Y; % number of Science classes (integer)

% Constraints
constraint X + Y >= 50;        % at least 50 classes total
constraint X <= 2 * Y;         % no more than twice as many Math as Science
constraint X - Y <= 20;        % difference not exceeding 20 (Math - Science)

% Objective: minimize total cost
var int: total_cost = 4 * X + 3 * Y;

solve minimize total_cost;

output [
  "X=", show(X), "\n",
  "Y=", show(Y), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "rounded_min_total_cost=", show(total_cost), "\n"
];