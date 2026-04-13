% Real estate development optimization (all data embedded)

int: max_total_properties = 100;

int: profit_condo = 5000;
int: profit_apartment = 3000;

% Living-area agreement (interpreted as linear constraint):
% 60*X + 30*Y >= 3000
int: area_coeff_condo = 60;
int: area_coeff_apartment = 30;
int: min_area = 3000;

var 0..max_total_properties: X; % luxury condos
var 0..max_total_properties: Y; % affordable apartments

constraint X + Y <= max_total_properties;
constraint area_coeff_condo * X + area_coeff_apartment * Y >= min_area;

var int: profit = profit_condo * X + profit_apartment * Y;

solve maximize profit;

output [
  "X (condos) = ", show(X), "\n",
  "Y (apartments) = ", show(Y), "\n",
  "Maximum profit ($) = ", show(profit), "\n"
];