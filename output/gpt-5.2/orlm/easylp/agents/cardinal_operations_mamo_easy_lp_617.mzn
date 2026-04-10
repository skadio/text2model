% Parameters
% Unit costs per unit of resource allocated to each project
int: cost_x1 = 200;
int: cost_x2 = 300;
int: cost_x3 = 150;
int: cost_x4 = 400;

% Constraint limits
int: lim_x1_x2 = 1000;      % x1 + x2 <= 1000
int: lim_2x2_x3 = 1200;     % 2*x2 + x3 <= 1200
int: min_3x1_halfx3 = 500;  % 3*x1 - 0.5*x3 >= 500

% Resource allocation bounds (explicit non-negativity; safe upper bound implied by constraints)
int: lb = 0;
int: ub = 1200;

% Variables
% Integer resource allocations to projects (indivisible units)
var lb..ub: x1;
var lb..ub: x2;
var lb..ub: x3;
var lb..ub: x4;

% Total cost variable (upper bound for clarity)
var 0..(cost_x1*ub + cost_x2*ub + cost_x3*ub + cost_x4*ub): total_cost;

% Constraints
% --- Budget/manpower coupling constraints ---
constraint x1 + x2 <= lim_x1_x2;
constraint 2 * x2 + x3 <= lim_2x2_x3;

% --- Minimum requirement / feasibility constraint (avoid fractions) ---
% 3*x1 - 0.5*x3 >= 500  <=>  6*x1 - x3 >= 1000
constraint 6 * x1 - x3 >= 2 * min_3x1_halfx3;

% --- Cross-project ordering constraint ---
constraint x4 >= x1;

% --- Total cost definition constraint ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Objective
solve minimize total_cost;

% Output (includes optimal allocations and minimum total cost)
output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];