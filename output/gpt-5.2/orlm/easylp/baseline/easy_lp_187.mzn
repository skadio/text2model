% Manufacturing production planning - minimize total cost

% Parameters (embedded data)
int: A_avail = 1000;
int: B_avail = 800;

int: demand_rhs = 100;

int: max_x1 = 300;
int: max_x2 = 200;
int: max_x3 = 150;

int: cost_x1 = 10;
int: cost_x2 = 15;
int: cost_x3 = 20;

% Decision variables (integer production quantities)
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

% Resource constraints
constraint 5*x1 + 3*x2 + 8*x3 <= A_avail;
constraint 4*x1 + 6*x2 + 7*x3 <= B_avail;

% Demand constraint: x1 - 2*x2 + x3 >= 100
constraint x1 - 2*x2 + x3 >= demand_rhs;

% Objective: minimize total cost
var int: total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];