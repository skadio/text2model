% Real estate development: minimize investment cost with demand and capacity constraints.

int: cost_house = 400000;
int: cost_apartment = 600000;

% Constraints (scaled to avoid fractions):
% Market demand: 1.5x + 2y >= 500  ->  3x + 4y >= 1000
% Capacity limit: 0.75x + y <= 300 ->  3x + 4y <= 1200
% Hence: 1000 <= 3x + 4y <= 1200

var 0..10000: x; % number of houses
var 0..10000: y; % number of apartments

constraint 3*x + 4*y >= 1000;
constraint 3*x + 4*y <= 1200;

var int: total_investment = cost_house * x + cost_apartment * y;

solve minimize total_investment;

output [
  "houses (x) = ", show(x), "\n",
  "apartments (y) = ", show(y), "\n",
  "total_investment = $", show(total_investment), "\n"
];