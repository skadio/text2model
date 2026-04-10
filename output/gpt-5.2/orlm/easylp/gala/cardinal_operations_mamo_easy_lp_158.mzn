% Real estate investment minimization (all data embedded)

% Decision variables (whole numbers of buildings)
var 0..10000: x;  % number of houses
var 0..10000: y;  % number of apartments

% Constraints:
% Market demand: 1.5x + 2y >= 500  -> multiply by 2: 3x + 4y >= 1000
constraint 3 * x + 4 * y >= 1000;

% Capacity: 0.75x + y <= 300 -> multiply by 4: 3x + 4y <= 1200
constraint 3 * x + 4 * y <= 1200;

% Objective: minimize total investment
% (in dollars) 400,000 per house and 600,000 per apartment
var int: total_investment = 400000 * x + 600000 * y;

solve minimize total_investment;

output [
  "x (houses) = ", show(x), "\n",
  "y (apartments) = ", show(y), "\n",
  "Minimum total investment ($) = ", show(total_investment), "\n"
];