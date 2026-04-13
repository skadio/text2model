% Headphone production optimization (all data embedded)

% Decision variables: number produced per day
var 0..100: wired;       % wired team capacity
var 0..170: wireless;    % wireless team capacity

% Shared testing machine capacity
constraint wired + wireless <= 150;

% Profit (USD)
var int: profit = 50 * wired + 20 * wireless;

solve maximize profit;

output [
  "wired = ", show(wired), "\n",
  "wireless = ", show(wireless), "\n",
  "profit = ", show(profit), "\n"
];