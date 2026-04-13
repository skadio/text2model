% Bakery production optimization: bagels and croissants

% Data (embedded)
float: oven_available = 70.0;
float: chef_available = 32.0;

float: oven_bagel = 2.0;
float: chef_bagel = 0.25;
float: profit_bagel = 20.0;

float: oven_croissant = 1.0;
float: chef_croissant = 2.0;
float: profit_croissant = 40.0;

% Decision variables (batches produced; allow fractional batches)
var 0.0..1000.0: bagels;
var 0.0..1000.0: croissants;

% Constraints: use all available capacity
constraint oven_bagel * bagels + oven_croissant * croissants = oven_available;
constraint chef_bagel * bagels + chef_croissant * croissants = chef_available;

% Objective: maximize profit
var float: total_profit = profit_bagel * bagels + profit_croissant * croissants;
solve maximize total_profit;

output [
  "bagels_batches = ", show(bagels), "\n",
  "croissants_batches = ", show(croissants), "\n",
  "total_profit = $", show(total_profit), "\n"
];