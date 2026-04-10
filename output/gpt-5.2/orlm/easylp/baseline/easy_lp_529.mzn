% Resource allocation minimization for three departments

int: BUDGET = 2000;

int: max_inventory = 1500;
int: max_advertising = 800;
int: max_service = 1200;

int: cost_inventory = 5;
int: cost_advertising = 3;
int: cost_service = 7;

% Decision variables (whole-number allocations)
var 0..max_inventory: x1; % inventory
var 0..max_advertising: x2; % advertising
var 0..max_service: x3; % customer service

% Total allocation cannot exceed budget
constraint x1 + x2 + x3 <= BUDGET;

% 2*x1 - 0.5*x2 >= 500  -> multiply by 2: 4*x1 - x2 >= 1000
constraint 4 * x1 - x2 >= 1000;

% x3 - 0.8*x1 <= 1000 -> multiply by 5: 5*x3 - 4*x1 <= 5000
constraint 5 * x3 - 4 * x1 <= 5000;

% Objective: minimize total cost
var int: total_cost = cost_inventory * x1 + cost_advertising * x2 + cost_service * x3;
solve minimize total_cost;

output [
  "x1(inventory)=", show(x1), "\n",
  "x2(advertising)=", show(x2), "\n",
  "x3(customer_service)=", show(x3), "\n",
  "min_total_cost=", show(total_cost), "\n",
  "rounded_min_total_cost=", show(total_cost), "\n"
];