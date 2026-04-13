% Parameters
float: slicer_hours_per_ham = 4.0;
float: packer_hours_per_ham = 2.5;
float: slicer_hours_per_ribs = 2.0;
float: packer_hours_per_ribs = 3.5;

float: slicer_capacity = 4000.0;
float: packer_capacity = 4000.0;

int: profit_per_ham = 150;
int: profit_per_ribs = 300;

% Variables
var 0..2000: ham_batches;
var 0..2000: ribs_batches;

var int: total_profit;

% Constraints
constraint slicer_hours_per_ham * ham_batches + slicer_hours_per_ribs * ribs_batches <= slicer_capacity;
constraint packer_hours_per_ham * ham_batches + packer_hours_per_ribs * ribs_batches <= packer_capacity;

constraint total_profit = profit_per_ham * ham_batches + profit_per_ribs * ribs_batches;

% Objective
solve maximize total_profit;