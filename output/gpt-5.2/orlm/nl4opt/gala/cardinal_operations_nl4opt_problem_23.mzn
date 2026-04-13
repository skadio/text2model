% School transport pollution minimization
% Data embedded as required.

int: kids_min = 150;

int: van_capacity = 6;
int: van_pollution = 7;

int: minibus_capacity = 10;
int: minibus_pollution = 10;

int: max_minibuses = 10;

% Decision variables
var 0..1000: vans;
var 0..max_minibuses: minibuses;

% Constraints
constraint van_capacity * vans + minibus_capacity * minibuses >= kids_min;
constraint vans > minibuses;

% Objective
var int: total_pollution = van_pollution * vans + minibus_pollution * minibuses;

solve minimize total_pollution;

output [
  "vans = ", show(vans), "\n",
  "minibuses = ", show(minibuses), "\n",
  "kids_capacity = ", show(van_capacity * vans + minibus_capacity * minibuses), "\n",
  "total_pollution = ", show(total_pollution), "\n"
];