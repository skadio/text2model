% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

array[P] of int: cost = [5, 7, 3, 8];

int: limit1 = 1500;   % x1 + 2*x2 <= 1500
int: thresh2 = 1000;  % 3*x1 + x3 >= 1000
int: limit3 = 600;    % 4*x4 - x2 <= 600
int: deficit = -200;  % -x1 + x2 + x3 + x4 = -200

array[P] of int: ub = [500, 400, 300, 200];

% Variables
var 0..ub[1]: x1;
var 0..ub[2]: x2;
var 0..ub[3]: x3;
var 0..ub[4]: x4;

% Constraints
constraint x1 + 2 * x2 <= limit1;
constraint 3 * x1 + x3 >= thresh2;
constraint 4 * x4 - x2 <= limit3;
constraint (-x1 + x2 + x3 + x4) = deficit;

% Objective
var int: total_cost = cost[1]*x1 + cost[2]*x2 + cost[3]*x3 + cost[4]*x4;
solve minimize total_cost;