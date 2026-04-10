% Resource allocation cost minimization (all integer allocations)

% Costs ($ per unit)
int: cost_raw = 20;
int: cost_lab = 30;
int: cost_mac = 10;

% Bounds (units)
int: raw_min = 0;    int: raw_max = 2000;
int: lab_min = 0;    int: lab_max = 1500;
int: mac_min = 0;    int: mac_max = 700;

% Decision variables (whole-number allocations)
var raw_min..raw_max: raw;
var lab_min..lab_max: lab;
var mac_min..mac_max: mac;

% Constraints
constraint raw + lab >= 1000;
constraint abs(lab - mac) <= 500;
constraint raw - 2 * mac >= 400;

% Objective: minimize total cost
var int: total_cost = cost_raw * raw + cost_lab * lab + cost_mac * mac;

solve minimize total_cost;

output [
  "raw = ", show(raw), "\n",
  "lab = ", show(lab), "\n",
  "mac = ", show(mac), "\n",
  "total_cost = ", show(total_cost), "\n"
];