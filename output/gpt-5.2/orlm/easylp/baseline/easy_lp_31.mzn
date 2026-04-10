% Transportation company trip planning - all data embedded

int: max_total_trips = 10000;
int: min_x_trips = 3000;
int: min_y_trips = 2000;

% Costs in cents to avoid floating point issues
int: cost_x_cents = 50;   % $0.5
int: cost_y_cents = 100;  % $1

var int: x_trips >= min_x_trips;
var int: y_trips >= min_y_trips;

constraint x_trips + y_trips <= max_total_trips;

var int: total_cost_cents = cost_x_cents * x_trips + cost_y_cents * y_trips;

solve minimize total_cost_cents;

% Nearest dollar from cents: (cents + 50) div 100
var int: total_cost_rounded_dollars = (total_cost_cents + 50) div 100;

output [
  "x_trips=", show(x_trips), "\n",
  "y_trips=", show(y_trips), "\n",
  "min_total_cost_rounded_dollars=", show(total_cost_rounded_dollars), "\n"
];