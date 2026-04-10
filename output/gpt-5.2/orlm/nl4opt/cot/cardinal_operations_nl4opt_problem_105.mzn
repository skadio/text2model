% Parameters (with values embedded)
int: max_hours = 4000;

float: slicer_hours_ham = 4.0;
float: packer_hours_ham = 2.5;

float: slicer_hours_ribs = 2.0;
float: packer_hours_ribs = 3.5;

int: profit_ham = 150;
int: profit_ribs = 300;

% Variables
var 0..1000000: hams_batches;
var 0..1000000: ribs_batches;
var int: total_profit;

% Constraints
constraint slicer_hours_ham * int2float(hams_batches) + slicer_hours_ribs * int2float(ribs_batches) <= int2float(max_hours);
constraint packer_hours_ham * int2float(hams_batches) + packer_hours_ribs * int2float(ribs_batches) <= int2float(max_hours);

constraint total_profit = profit_ham * hams_batches + profit_ribs * ribs_batches;

% Objective
solve maximize total_profit;