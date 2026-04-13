% Parameters
% Processing times (hours per batch)
float: slicer_hours_per_ham  = 4.0;
float: packer_hours_per_ham  = 2.5;
float: slicer_hours_per_ribs = 2.0;
float: packer_hours_per_ribs = 3.5;

% Machine capacity (hours per year)
float: max_hours_per_machine = 4000.0;

% Profit per batch ($)
int: profit_per_ham  = 150;
int: profit_per_ribs = 300;

% Variables
% Number of batches produced (non-negative integers)
var 0..100000: ham_batches;   % batches of hams
var 0..100000: ribs_batches;  % batches of pork ribs

% Constraints
% --- Machine capacity constraints (annual available hours) ---
% Total slicer time used by ham and ribs batches must not exceed capacity
constraint
  slicer_hours_per_ham  * int2float(ham_batches)
+ slicer_hours_per_ribs * int2float(ribs_batches)
<= max_hours_per_machine;

% Total packer time used by ham and ribs batches must not exceed capacity
constraint
  packer_hours_per_ham  * int2float(ham_batches)
+ packer_hours_per_ribs * int2float(ribs_batches)
<= max_hours_per_machine;

% Objective
solve maximize profit_per_ham * ham_batches + profit_per_ribs * ribs_batches;