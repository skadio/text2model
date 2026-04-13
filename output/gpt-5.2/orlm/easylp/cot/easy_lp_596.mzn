% Parameters (with values embedded)
int: avail1 = 700;
int: avail2 = 500;
int: avail3 = 600;
int: avail4 = 800;

int: cost1 = 50;
int: cost2 = 60;
int: cost3 = 70;
int: cost4 = 80;

int: op1_cap = 1000;  % x1 + x2
int: op2_cap = 1200;  % x3 + x4

int: heavy_min = 800; % x1 + x3
int: req_min   = 600; % x2 + x4

% Variables
var 0..avail1: x1;
var 0..avail2: x2;
var 0..avail3: x3;
var 0..avail4: x4;

var 0..(cost1*avail1 + cost2*avail2 + cost3*avail3 + cost4*avail4): total_cost;

% Constraints
constraint x1 + x2 <= op1_cap;
constraint x3 + x4 <= op2_cap;

constraint x1 + x3 >= heavy_min;
constraint x2 + x4 >= req_min;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "minimum_daily_operating_cost=", show(total_cost), "\n"
];