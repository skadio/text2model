% Shipping vans optimization (all data embedded)

% Parameters
int: reg_capacity = 500;     % packages/day per regular van
int: reg_pollution = 200;    % pollution units/day per regular van

int: hyb_capacity = 300;     % packages/day per hybrid van
int: hyb_pollution = 100;    % pollution units/day per hybrid van

int: max_pollution = 7000;   % max pollution units/day
int: min_packages = 20000;   % required packages/day

% Decision variables: number of vans to buy
var 0..100000: reg_vans;
var 0..100000: hyb_vans;

% Objective: minimize total vans
var 0..200000: total_vans = reg_vans + hyb_vans;

% Constraints
constraint reg_pollution * reg_vans + hyb_pollution * hyb_vans <= max_pollution;
constraint reg_capacity  * reg_vans + hyb_capacity  * hyb_vans >= min_packages;

solve minimize total_vans;

output [
  "Regular vans: ", show(reg_vans), "\n",
  "Hybrid vans: ", show(hyb_vans), "\n",
  "Total vans: ", show(total_vans), "\n",
  "Total packages/day: ", show(reg_capacity*reg_vans + hyb_capacity*hyb_vans), "\n",
  "Total pollution/day: ", show(reg_pollution*reg_vans + hyb_pollution*hyb_vans), "\n"
];