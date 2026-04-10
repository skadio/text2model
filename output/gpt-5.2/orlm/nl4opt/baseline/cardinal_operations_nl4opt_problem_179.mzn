int: total_invest = 600000;
int: max_apartments = 200000;

% Decision variables (in dollars)
var 0..max_apartments: A;                 % apartments investment
var 0..total_invest: T;                   % townhouses investment

% Use integer arithmetic for profit in "percent-dollars"
% (profit_percent_dollars = 10*A + 15*T)
var int: profit = 10*A + 15*T;

constraint A + T = total_invest;
constraint A >= T div 2;                  % A >= 0.5 * T (integer-safe)

solve maximize profit;

output [
  "Apartments investment: $", show(A), "\n",
  "Townhouses investment: $", show(T), "\n",
  "Profit: $", show( (10*A + 15*T) div 100 ), "\n"
];