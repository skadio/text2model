% Bakery production planning (linear/integer optimization)

% Data (embedded as requested)
int: max_hours = 3000;

% Resource usage per unit
float: mix_bread = 1.0;
float: oven_bread = 3.0;
float: mix_cookies = 0.5;
float: oven_cookies = 1.0;

% Profit per unit
int: profit_bread = 5;
int: profit_cookies = 3;

% Decision variables (nonnegative integers)
var 0..1000000: bread;    % loaves per year
var 0..1000000: cookies;  % batches per year

% Capacity constraints
constraint mix_bread * bread + mix_cookies * cookies <= max_hours;
constraint oven_bread * bread + oven_cookies * cookies <= max_hours;

% Objective: maximize total profit
var int: total_profit = profit_bread * bread + profit_cookies * cookies;
solve maximize total_profit;

output [
  "Bread loaves = ", show(bread), "\n",
  "Cookie batches = ", show(cookies), "\n",
  "Total profit = $", show(total_profit), "\n",
  "Mixer hours used = ", show(mix_bread * bread + mix_cookies * cookies), "\n",
  "Oven hours used = ", show(oven_bread * bread + oven_cookies * cookies), "\n"
];