% Meat processing plant production planning (maximize profit)
% Data is embedded as required.

% Parameters
float: slicer_hours_per_ham  = 4.0;
float: packer_hours_per_ham  = 2.5;
float: slicer_hours_per_ribs = 2.0;
float: packer_hours_per_ribs = 3.5;

float: slicer_capacity = 4000.0;
float: packer_capacity = 4000.0;

int: profit_ham  = 150;
int: profit_ribs = 300;

% Decision variables: integer number of batches
var 0..2000: ham;   % upper bounds from capacities: ham <= 4000/2 = 2000
var 0..2000: ribs;  % ribs <= 4000/2 = 2000

% Constraints (avoid floats by multiplying by 2)
% Slicer: 4*ham + 2*ribs <= 4000  ==> 8*ham + 4*ribs <= 8000
constraint 8*ham + 4*ribs <= 8000;

% Packer: 2.5*ham + 3.5*ribs <= 4000  ==> 5*ham + 7*ribs <= 8000
constraint 5*ham + 7*ribs <= 8000;

% Objective
var int: profit = profit_ham*ham + profit_ribs*ribs;

solve maximize profit;

output [
  "ham_batches = ", show(ham), "\n",
  "ribs_batches = ", show(ribs), "\n",
  "profit = $", show(profit), "\n"
];