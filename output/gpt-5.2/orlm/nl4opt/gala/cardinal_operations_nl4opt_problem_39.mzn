include "globals.mzn";

% Data (embedded from problem statement)
int: min_choc = 5;
int: min_van  = 5;
int: max_choc = 10;
int: max_van  = 8;

int: hours_per_choc = 1;
int: hours_per_van  = 2;
int: total_hours    = 30;

int: base_workers_min = 6;
int: workers_per_choc = 1;
int: workers_per_van  = 2;

int: profit_choc = 200;
int: profit_van  = 300;

% Decision variables: gallons to make (integers)
var min_choc..max_choc: choc;
var min_van..max_van: van;

% Resource constraints
constraint hours_per_choc * choc + hours_per_van * van <= total_hours;

% Worker requirement (interpreted as total workers needed to run the production plan)
var int: workers_needed = base_workers_min + workers_per_choc * choc + workers_per_van * van;
constraint workers_needed >= base_workers_min; % redundant but explicit

% Objective: maximize profit
var int: profit = profit_choc * choc + profit_van * van;

solve maximize profit;

output [
  "Chocolate gallons = ", show(choc), "\n",
  "Vanilla gallons   = ", show(van), "\n",
  "Total hours used  = ", show(hours_per_choc * choc + hours_per_van * van), " / ", show(total_hours), "\n",
  "Workers needed    = ", show(workers_needed), " (min base ", show(base_workers_min), ")\n",
  "Profit            = $", show(profit), "\n"
];