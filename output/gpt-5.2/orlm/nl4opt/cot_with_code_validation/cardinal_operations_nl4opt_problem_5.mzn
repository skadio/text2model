% Flooring production optimization (all data embedded)

% Parameters
int: min_hardwood = 20000;
int: min_vinyl    = 10000;
int: min_total    = 60000;

int: max_hardwood = 50000;
int: max_vinyl    = 30000;

% Use integer profits in cents to avoid float objective (faster/more robust)
int: profit_hardwood_cents = 250; % $2.50
int: profit_vinyl_cents    = 300; % $3.00

% Decision variables (square feet produced)
var min_hardwood..max_hardwood: hardwood;
var min_vinyl..max_vinyl: vinyl;

% Constraints
constraint hardwood + vinyl >= min_total;

% Objective (maximize profit in cents)
var int: total_profit_cents = profit_hardwood_cents * hardwood
                           + profit_vinyl_cents * vinyl;

solve maximize total_profit_cents;

output [
  "hardwood = ", show(hardwood), "\n",
  "vinyl = ", show(vinyl), "\n",
  "total_profit_cents = ", show(total_profit_cents), "\n"
];