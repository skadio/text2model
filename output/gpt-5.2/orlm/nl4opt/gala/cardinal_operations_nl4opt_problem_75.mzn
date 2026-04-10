% Shoe delivery: minimize number of vans
% Data embedded (no .dzn)

int: van_capacity = 50;
int: truck_capacity = 100;
int: demand = 2000;

% Decision variables
var 0..demand div van_capacity: vans;    % upper bound: all vans
var 0..demand div truck_capacity: trucks;

% Constraints
constraint van_capacity * vans + truck_capacity * trucks >= demand;
constraint trucks <= vans;

% Objective: minimum number of vans
solve minimize vans;

output [
  "vans = ", show(vans), "\n",
  "trucks = ", show(trucks), "\n",
  "total_pairs = ", show(van_capacity * vans + truck_capacity * trucks), "\n"
];