% Bakery production planning: maximize profit under resource limits

include "globals.mzn";

% Data (embedded as required)
int: oven_cap = 70;          % hours available
int: chef_cap = 32;          % pastry chef hours available

% Per-batch resource use
int: oven_bagel = 2;
float: chef_bagel = 0.25;

int: oven_croissant = 1;
int: chef_croissant = 2;

% Profit per batch
int: profit_bagel = 20;
int: profit_croissant = 40;

% Decision variables: number of batches (nonnegative integers)
var 0..oven_cap div oven_bagel: bagels;
var 0..oven_cap div oven_croissant: croissants;

% Constraints
constraint oven_bagel * bagels + oven_croissant * croissants <= oven_cap;
constraint chef_bagel * int2float(bagels) + chef_croissant * int2float(croissants) <= chef_cap;

% Objective
var int: profit = profit_bagel * bagels + profit_croissant * croissants;
solve maximize profit;

output [
  "Bagel batches = ", show(bagels), "\n",
  "Croissant batches = ", show(croissants), "\n",
  "Profit = $", show(profit), "\n",
  "Oven used = ", show(oven_bagel * bagels + oven_croissant * croissants), " / ", show(oven_cap), "\n",
  "Chef used = ", show(chef_bagel * int2float(bagels) + chef_croissant * int2float(croissants)), " / ", show(chef_cap), "\n"
];