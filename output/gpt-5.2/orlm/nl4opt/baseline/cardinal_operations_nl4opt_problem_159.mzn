% Headphone production profit maximization (all data embedded)

% Decision variables
var 0..100: wired;        % wired headphones per day (wired team capacity)
var 0..170: wireless;     % wireless headphones per day (wireless team capacity)

% Shared testing machine capacity
constraint wired + wireless <= 150;

% Objective: maximize profit
var int: profit = 50 * wired + 20 * wireless;
solve maximize profit;

output [
  "wired = ", show(wired), "\n",
  "wireless = ", show(wireless), "\n",
  "profit = ", show(profit), "\n"
];