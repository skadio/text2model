% Zeta Bakery cookie production (maximize profit)

% Data (embedded as requested)
int: max_strawberry_demand = 100;
int: max_sugar_demand      = 80;
int: max_total_cookies     = 100;

float: profit_strawberry = 5.5;
float: profit_sugar      = 12.0;

% Decision variables
var 0..max_strawberry_demand: x1;  % strawberry cookies
var 0..max_sugar_demand: x2;       % sugar cookies

% Constraints
constraint x1 + x2 <= max_total_cookies;

% Objective
var float: total_profit = profit_strawberry * int2float(x1)
                        + profit_sugar * int2float(x2);

solve maximize total_profit;

output [
  "Strawberry cookies (x1) = ", show(x1), "\n",
  "Sugar cookies (x2) = ", show(x2), "\n",
  "Total profit = $", show(total_profit), "\n"
];