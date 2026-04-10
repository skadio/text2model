% Zeta Bakery cookie production optimization (embedded data)

% Decision variables
var 0..100: x1; % strawberry cookies
var 0..80:  x2; % sugar cookies

% Constraints
constraint x1 <= 100;          % demand limit for strawberry
constraint x2 <= 80;           % demand limit for sugar
constraint x1 + x2 <= 100;     % staffing/production capacity

% Objective: maximize profit
var float: profit = 5.5 * int2float(x1) + 12.0 * int2float(x2);
solve maximize profit;

output [
  "strawberry_cookies=", show(x1), "\n",
  "sugar_cookies=", show(x2), "\n",
  "profit=", show(profit), "\n"
];