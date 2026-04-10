% Flooring production optimization (all data embedded)

% Parameters (sq ft)
int: hardwood_min = 20000;
int: vinyl_min    = 10000;
int: total_min    = 60000;

int: hardwood_max = 50000;
int: vinyl_max    = 30000;

% Profits ($ per sq ft) - use integer cents to avoid floating point
int: profit_h_cents = 250;  % $2.50
int: profit_v_cents = 300;  % $3.00

% Decision variables (sq ft produced)
var hardwood_min..hardwood_max: hardwood;
var vinyl_min..vinyl_max: vinyl;

% Constraints
constraint hardwood + vinyl >= total_min;

% Objective: maximize profit in cents
var int: profit_cents = profit_h_cents * hardwood + profit_v_cents * vinyl;

solve maximize profit_cents;

output [
  "Hardwood (sq ft) = ", show(hardwood), "\n",
  "Vinyl (sq ft)    = ", show(vinyl), "\n",
  "Total (sq ft)    = ", show(hardwood + vinyl), "\n",
  "Profit ($)       = ", show(profit_cents div 100), ".", 
                        if profit_cents mod 100 < 10 then "0" else "" endif,
                        show(profit_cents mod 100), "\n"
];