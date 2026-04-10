% Parameters
% Unit production costs
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;

% Capacity / relationship limits
int: cap1   = 1000;   % x1 + 2*x2 <= 1000
int: diff13 = 300;    % 3*x1 >= x3 + 300
int: cap2   = 1500;   % 4*x2 + x3 <= 1500
int: cap3   = 70;     % 5*x2 - (x1 + x3) <= 70

% Production bounds (default to non-negative as not otherwise specified)
int: lb_x1 = 0;
int: lb_x2 = 0;
int: lb_x3 = 0;

% Upper bounds derived from constraints for tighter domains
int: ub_x1 = cap1;         % from x1 + 2*x2 <= 1000 with x2>=0
int: ub_x2 = cap1 div 2;   % from x1 + 2*x2 <= 1000 with x1>=0
int: ub_x3 = cap2;         % from 4*x2 + x3 <= 1500 with x2>=0


% Variables
var lb_x1..ub_x1: x1;   % units of product x1 (integer)
var lb_x2..ub_x2: x2;   % units of product x2 (integer)
var lb_x3..ub_x3: x3;   % units of product x3 (integer)

var int: total_cost;    % total production cost


% Constraints
% --- Capacity constraint 1: x1 + 2*x2 <= 1000
constraint x1 + 2 * x2 <= cap1;

% --- Relationship constraint: 3*x1 must be at least x3 + 300
constraint 3 * x1 >= x3 + diff13;

% --- Capacity constraint 2: 4*x2 + x3 <= 1500
constraint 4 * x2 + x3 <= cap2;

% --- Difference constraint: 5*x2 - (x1 + x3) <= 70
constraint 5 * x2 - (x1 + x3) <= cap3;

% --- Total cost definition
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "total_cost=", show(total_cost), "\n"
];