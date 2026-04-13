% Parameters
int: max_x1 = 300;              % Maximum allowable units of product x1
int: max_x2 = 200;              % Maximum allowable units of product x2
int: max_x3 = 150;              % Maximum allowable units of product x3

int: avail_A = 1000;            % Total availability of resource A
int: avail_B = 800;             % Total availability of resource B

int: req_A_x1 = 5;              % Resource A used per unit of x1
int: req_B_x1 = 4;              % Resource B used per unit of x1
int: req_A_x2 = 3;              % Resource A used per unit of x2
int: req_B_x2 = 6;              % Resource B used per unit of x2
int: req_A_x3 = 8;              % Resource A used per unit of x3
int: req_B_x3 = 7;              % Resource B used per unit of x3

int: demand_rhs = 100;          % Minimum required value of (x1 - 2*x2 + x3)

int: cost_x1 = 10;              % Cost per unit of x1
int: cost_x2 = 15;              % Cost per unit of x2
int: cost_x3 = 20;              % Cost per unit of x3

% Variables
var 0..max_x1: x1;              % Units produced of product x1 (integer, bounded)
var 0..max_x2: x2;              % Units produced of product x2 (integer, bounded)
var 0..max_x3: x3;              % Units produced of product x3 (integer, bounded)

% Upper bound is the maximum possible total cost given variable bounds
var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3): total_cost;

% Constraints
%-----------------------------
% Total cost definition (linking)
%-----------------------------
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

%-----------------------------
% Resource capacity constraints
%-----------------------------
constraint
  req_A_x1 * x1 + req_A_x2 * x2 + req_A_x3 * x3 <= avail_A;

constraint
  req_B_x1 * x1 + req_B_x2 * x2 + req_B_x3 * x3 <= avail_B;

%-----------------------------
% Demand satisfaction constraint
%-----------------------------
constraint
  x1 - 2 * x2 + x3 >= demand_rhs;

% Objective
solve minimize total_cost;