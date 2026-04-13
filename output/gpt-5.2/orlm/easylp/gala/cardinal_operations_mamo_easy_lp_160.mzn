% Real estate developer profit maximization
% Build X luxury condos and Y affordable apartments (integers)

int: max_total = 100;

int: profit_condo = 5000;
int: profit_apt   = 3000;

% Community development agreement:
% "combined living area provided by 60 condos plus 30 apartments must be at least 3000 sq ft"
% Interpreted as: 60*X + 30*Y >= 3000
int: a_condo = 60;
int: a_apt   = 30;
int: min_area = 3000;

var 0..max_total: X; % condos
var 0..max_total: Y; % apartments

constraint X + Y <= max_total;
constraint a_condo * X + a_apt * Y >= min_area;

var int: profit = profit_condo * X + profit_apt * Y;

solve maximize profit;

output [
  "X (condos) = ", show(X), "\n",
  "Y (apartments) = ", show(Y), "\n",
  "Max profit ($) = ", show(profit), "\n"
];