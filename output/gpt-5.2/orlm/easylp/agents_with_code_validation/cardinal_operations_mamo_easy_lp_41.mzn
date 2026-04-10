% Portfolio allocation (integer dollars), minimize total cost

% Parameters
int: budget = 10000;
int: min_invest_x = 2000;
int: min_invest_y = 3000;

% Use integer cents-per-dollar rates to avoid float linear issues in Gecode
int: cost_cents_per_dollar_x = 2;   % $0.02 = 2 cents per $1
int: cost_cents_per_dollar_y = 3;   % $0.03 = 3 cents per $1

% Decision variables (integer dollars)
var min_invest_x..budget: invest_x;
var min_invest_y..budget: invest_y;

% Derived values
var int: total_cost_cents;
var int: total_cost_rounded_dollars;

% Constraints
constraint invest_x + invest_y <= budget;

constraint total_cost_cents =
  cost_cents_per_dollar_x * invest_x + cost_cents_per_dollar_y * invest_y;

% Rounded to nearest dollar: floor((cents + 50)/100)
constraint total_cost_rounded_dollars = (total_cost_cents + 50) div 100;

% Objective (minimize true cost; cents equivalent)
solve minimize total_cost_cents;

output [
  "invest_x = ", show(invest_x), "\n",
  "invest_y = ", show(invest_y), "\n",
  "total_cost_cents = ", show(total_cost_cents), "\n",
  "total_cost_rounded = ", show(total_cost_rounded_dollars), "\n"
];