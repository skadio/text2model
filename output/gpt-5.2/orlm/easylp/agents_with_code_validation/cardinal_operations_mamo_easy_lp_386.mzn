% Parameters
int: cost_x1 = 50;    % cost per tour in category x1
int: cost_x2 = 100;   % cost per tour in category x2
int: cost_x3 = 70;    % cost per tour in category x3
int: cost_x4 = 120;   % cost per tour in category x4

int: max_x1_x2 = 500; % resource limit for x1 + x2
int: max_x3_x4 = 300; % logistics limit for x3 + x4

int: min_demand_12 = 400; % minimum demand threshold for 2*x1 + 4*x2
int: min_demand_34 = 250; % minimum demand threshold for 3*x3 + 2*x4


% Variables
var 0..max_x1_x2: x1; % number of tours of type x1 (non-negative integer)
var 0..max_x1_x2: x2; % number of tours of type x2 (non-negative integer)
var 0..max_x3_x4: x3; % number of tours of type x3 (non-negative integer)
var 0..max_x3_x4: x4; % number of tours of type x4 (non-negative integer)

% Upper bound is a safe over-approximation based on max capacity in each group
var 0..(cost_x1*max_x1_x2 + cost_x2*max_x1_x2 + cost_x3*max_x3_x4 + cost_x4*max_x3_x4): total_cost;


% Constraints
% --- Capacity / resource limits ---
constraint x1 + x2 <= max_x1_x2;  % limited resources for categories x1 and x2
constraint x3 + x4 <= max_x3_x4;  % logistical restriction for categories x3 and x4

% --- Demand satisfaction constraints ---
constraint 2*x1 + 4*x2 >= min_demand_12;  % minimum demand for tours x1 and x2
constraint 3*x3 + 2*x4 >= min_demand_34;  % minimum demand for tours x3 and x4

% --- Total cost definition ---
constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), " x2=", show(x2), " x3=", show(x3), " x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];