% Ice cream production optimization (all data embedded)

% Decision variables: gallons produced (assume integer gallons)
var 5..10: chocolate;
var 5..8:  vanilla;

% Parameters
int: hours_per_chocolate = 1;
int: hours_per_vanilla   = 2;
int: total_hours         = 30;

int: workers_needed_chocolate = 1;
int: workers_needed_vanilla   = 2;
int: min_workers_total        = 6;

int: profit_chocolate = 200;
int: profit_vanilla   = 300;

% Constraints
constraint hours_per_chocolate * chocolate + hours_per_vanilla * vanilla <= total_hours;
constraint workers_needed_chocolate * chocolate + workers_needed_vanilla * vanilla >= min_workers_total;

% Objective: maximize profit
var int: profit = profit_chocolate * chocolate + profit_vanilla * vanilla;
solve maximize profit;

output [
  "Chocolate gallons = ", show(chocolate), "\n",
  "Vanilla gallons   = ", show(vanilla), "\n",
  "Profit            = $", show(profit), "\n"
];