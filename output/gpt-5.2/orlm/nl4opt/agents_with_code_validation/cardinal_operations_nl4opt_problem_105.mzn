% Parameters
% Machine hour requirements per batch (hours)
float: slicer_hours_per_ham   = 4.0;
float: packer_hours_per_ham   = 2.5;
float: slicer_hours_per_ribs  = 2.0;
float: packer_hours_per_ribs  = 3.5;

% Annual machine capacity (hours)
float: slicer_hours_available = 4000.0;
float: packer_hours_available = 4000.0;

% Profit per batch ($)
int: profit_per_ham  = 150;
int: profit_per_ribs = 300;

% Variables
% Number of batches to produce (nonnegative integers)
var 0..2000: ham_batches;   % safe upper bound
var 0..2000: ribs_batches;  % safe upper bound

% Constraints
% --- Machine capacity constraints (annual hours) ---

% Slicer capacity
constraint
  slicer_hours_per_ham * int2float(ham_batches)
+ slicer_hours_per_ribs * int2float(ribs_batches)
<= slicer_hours_available;

% Packer capacity
constraint
  packer_hours_per_ham * int2float(ham_batches)
+ packer_hours_per_ribs * int2float(ribs_batches)
<= packer_hours_available;

% Objective
solve maximize profit_per_ham * ham_batches + profit_per_ribs * ribs_batches;