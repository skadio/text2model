% Meat processing plant production planning (embedded data)

% Decision variables: number of batches (assumed integer, nonnegative)
var 0..100000: hams;
var 0..100000: ribs;

% Data (hours per batch)
float: slicer_hams = 4.0;
float: packer_hams = 2.5;
float: slicer_ribs = 2.0;
float: packer_ribs = 3.5;

% Machine capacity (hours per year)
float: max_hours = 4000.0;

% Profit per batch
int: profit_hams = 150;
int: profit_ribs = 300;

% Constraints (machine time limits)
constraint slicer_hams * int2float(hams) + slicer_ribs * int2float(ribs) <= max_hours;
constraint packer_hams * int2float(hams) + packer_ribs * int2float(ribs) <= max_hours;

% Objective: maximize total profit
var int: total_profit = profit_hams * hams + profit_ribs * ribs;
solve maximize total_profit;

output [
  "hams=", show(hams), "\n",
  "ribs=", show(ribs), "\n",
  "total_profit=", show(total_profit), "\n"
];