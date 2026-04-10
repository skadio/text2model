% Real estate investment optimization (all data embedded)

% Parameters (USD)
int: total = 600000;
int: aptMax = 200000;

% Decision variables (USD)
var 0..aptMax: apt;                 % amount invested in apartments
var 0..total: town;                 % amount invested in townhouses

% Constraints
constraint apt + town = total;
constraint apt >= town div 2;       % apartments at least half of townhouses (apt >= town/2)

% Profit (in cents) to keep everything integer:
% profit = 0.10*apt + 0.15*town
var int: profit_cents = 10 * apt + 15 * town;

solve maximize profit_cents;

output [
  "Apartments = $", show(apt), "\n",
  "Townhouses = $", show(town), "\n",
  "Profit = $", show(profit_cents div 100), ".", show((profit_cents mod 100) div 10), show(profit_cents mod 10), "\n"
];