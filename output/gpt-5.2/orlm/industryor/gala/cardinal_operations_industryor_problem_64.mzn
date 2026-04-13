% Production planning: microwaves and water heaters in workshops A and B
% All data embedded as per instructions.

% Decision variables (monthly quantities)
var 0..1000: m;  % microwave ovens produced/sold
var 0..1000: w;  % water heaters produced/sold

% Parameters (hours per unit)
int: A_m = 2;  int: B_m = 1;
int: A_w = 1;  int: B_w = 3;

% Available regular hours
int: A_cap = 250;
int: B_cap = 150;

% Overtime limit in A
int: A_ot_max = 20;

% Inspection & sales costs
int: c_m = 30;
int: c_w = 50;
int: c_cap = 5500;

% Demand (minimum sales)
int: m_min = 80;
int: w_min = 50;

% Labor costs per hour (not needed unless optimizing)
int: costA = 80;
int: costB = 20;

% Workshop time usage expressions
var 0..100000: A_hours = A_m*m + A_w*w;
var 0..100000: B_hours = B_m*m + B_w*w;

% Constraints
constraint c_m*m + c_w*w <= c_cap;   % (1) inspection/sales cost cap
constraint m >= m_min;               % (2) at least 80 microwaves
constraint w >= w_min;               % (5) at least 50 water heaters

% (3) fully utilized: B must be exactly full; A can use overtime but at least full regular time
constraint B_hours = B_cap;
constraint A_hours >= A_cap;

% (4) overtime in A limited
constraint A_hours <= A_cap + A_ot_max;

% Objective: not specified; choose a reasonable one.
% Minimize total production cost (workshop labor + inspection/sales).
var 0..100000000: total_cost =
    costA * A_hours + costB * B_hours + c_m*m + c_w*w;

solve minimize total_cost;

output [
  "Microwaves m = ", show(m), "\n",
  "Water heaters w = ", show(w), "\n",
  "Workshop A hours = ", show(A_hours), " (regular ", show(A_cap),
  ", overtime ", show(A_hours - A_cap), ")\n",
  "Workshop B hours = ", show(B_hours), " (capacity ", show(B_cap), ")\n",
  "Inspection+sales cost = ", show(c_m*m + c_w*w), " (cap ", show(c_cap), ")\n",
  "Total cost = ", show(total_cost), "\n"
];