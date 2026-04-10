% Parameters
int: oven_hours = 70;
int: chef_hours = 32;

int: profit_bagels = 20;
int: profit_croissants = 40;

int: oven_per_bagel = 2;
int: oven_per_croissant = 1;

float: chef_per_bagel = 0.25;
int: chef_per_croissant = 2;

% Variables
var 0..(oven_hours div oven_per_bagel): bagel_batches;
var 0..oven_hours: croissant_batches;

% Constraints
constraint oven_per_bagel * bagel_batches + oven_per_croissant * croissant_batches <= oven_hours;

constraint chef_per_bagel * int2float(bagel_batches)
         + int2float(chef_per_croissant * croissant_batches)
         <= int2float(chef_hours);

% Objective
solve maximize profit_bagels * bagel_batches + profit_croissants * croissant_batches;