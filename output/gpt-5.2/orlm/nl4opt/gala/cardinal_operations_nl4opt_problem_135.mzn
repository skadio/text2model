include "globals.mzn";

% Data (embedded from problem statement)
int: hours_needed = 300;
int: budget = 6500;

int: h_seasonal = 6;
int: pay_seasonal = 120;

int: h_permanent = 10;
int: pay_permanent = 250;

% Decision variables: number of workers hired of each type
var 0..ceil(hours_needed div 1): seasonal;
var 0..ceil(hours_needed div 1): permanent;

% Constraints
constraint h_seasonal * seasonal + h_permanent * permanent >= hours_needed;
constraint pay_seasonal * seasonal + pay_permanent * permanent <= budget;

% Objective: minimize total number of snow removers
var 0..10000: total_workers = seasonal + permanent;
solve minimize total_workers;

output [
  "seasonal = ", show(seasonal), "\n",
  "permanent = ", show(permanent), "\n",
  "total_workers = ", show(total_workers), "\n",
  "total_hours = ", show(h_seasonal*seasonal + h_permanent*permanent), "\n",
  "total_cost = ", show(pay_seasonal*seasonal + pay_permanent*permanent), "\n"
];