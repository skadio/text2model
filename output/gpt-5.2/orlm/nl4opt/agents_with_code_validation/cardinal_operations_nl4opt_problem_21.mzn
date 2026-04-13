% Parameters
% Resource capacities (hours available per day)
int: oven_hours_available = 70;
int: chef_hours_available = 32;

% Processing times per batch (hours)
float: oven_hours_per_bagel_batch = 2.0;
float: chef_hours_per_bagel_batch = 0.25;

float: oven_hours_per_croissant_batch = 1.0;
float: chef_hours_per_croissant_batch = 2.0;

% Profit per batch ($)
int: profit_per_bagel_batch = 20;
int: profit_per_croissant_batch = 40;


% Variables
% Number of batches produced (non-negative integers)
var 0..oven_hours_available: bagel_batches;
var 0..oven_hours_available: croissant_batches;

% Total profit ($)
var 0..(profit_per_bagel_batch * oven_hours_available
      + profit_per_croissant_batch * oven_hours_available): total_profit;


% Constraints
% Resource capacity constraints (do not exceed available hours)
constraint
  oven_hours_per_bagel_batch * int2float(bagel_batches)
+ oven_hours_per_croissant_batch * int2float(croissant_batches)
<= int2float(oven_hours_available);

constraint
  chef_hours_per_bagel_batch * int2float(bagel_batches)
+ chef_hours_per_croissant_batch * int2float(croissant_batches)
<= int2float(chef_hours_available);

% Total profit definition
constraint
  total_profit
= profit_per_bagel_batch * bagel_batches
+ profit_per_croissant_batch * croissant_batches;


% Objective
solve maximize total_profit;