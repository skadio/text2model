% Vehicle allocation: minimize operating cost
% Decision variables (whole numbers)
var 0..1000: trucks; % route X
var 0..1000: vans;   % route Y

% Data (embedded from problem statement)
int: cap_truck = 4;
int: cap_van   = 3;
int: demand    = 15;

int: restr_truck = 2;
int: restr_van   = 1;
int: restr_limit = 30;

int: cost_truck = 6;
int: cost_van   = 7;

% Constraints
constraint cap_truck * trucks + cap_van * vans >= demand;
constraint restr_truck * trucks + restr_van * vans <= restr_limit;

% Objective
var int: total_cost = cost_truck * trucks + cost_van * vans;

solve minimize total_cost;

output [
  "trucks = ", show(trucks), "\n",
  "vans = ", show(vans), "\n",
  "minimum_daily_cost = $", show(total_cost), "\n"
];