% Parameters
int: cost_x1 = 4;   % Unit cost for project x1
int: cost_x2 = 5;   % Unit cost for project x2
int: cost_x3 = 6;   % Unit cost for project x3
int: cost_x4 = 7;   % Unit cost for project x4

int: lb_x1 = 0;   int: ub_x1 = 100;  % Bounds for x1
int: lb_x2 = 0;   int: ub_x2 = 80;   % Bounds for x2
int: lb_x3 = 0;   int: ub_x3 = 60;   % Bounds for x3
int: lb_x4 = 0;   int: ub_x4 = 70;   % Bounds for x4

int: rhs1 = 50;   % x1 + 2*x2 <= 50
int: rhs2 = 20;   % 3*x3 - x4 >= 20
int: rhs3 = 30;   % x2 + x3 - x1 <= 30
int: rhs4 = 10;   % 3*x4 - x2 >= 10


% Variables
var lb_x1..ub_x1: x1;  % Resource allocation to project x1 (integer units)
var lb_x2..ub_x2: x2;  % Resource allocation to project x2 (integer units)
var lb_x3..ub_x3: x3;  % Resource allocation to project x3 (integer units)
var lb_x4..ub_x4: x4;  % Resource allocation to project x4 (integer units)

var int: total_cost;   % Total cost to be minimized


% Constraints
% Link total_cost to decision variables and unit costs
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;

% Budgetary limitation: x1 + 2*x2 <= 50
constraint
  x1 + 2 * x2 <= rhs1;

% Operational requirement: 3*x3 - x4 >= 20
constraint
  3 * x3 - x4 >= rhs2;

% Operational requirement: x2 + x3 - x1 <= 30
constraint
  x2 + x3 - x1 <= rhs3;

% Operational requirement: 3*x4 - x2 >= 10
constraint
  3 * x4 - x2 >= rhs4;


% Objective
solve minimize total_cost;