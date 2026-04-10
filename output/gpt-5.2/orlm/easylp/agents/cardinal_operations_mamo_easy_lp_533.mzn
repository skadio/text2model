% Parameters
% Unit costs ($ per unit) for each project
int: cost_x1 = 10;
int: cost_x2 = 20;
int: cost_x3 = 30;

% Constraint right-hand sides (RHS)
int: rhs1 = 2000;   % x1 + 2*x2 <= 2000
int: rhs2 = 1000;   % 3*x1 + 4*x3 >= 1000
int: rhs3 = 500;    % x2 - 5*x3 <= 500

% Lower bounds (non-negativity; no other explicit bounds were provided)
int: lb_x1 = 0;
int: lb_x2 = 0;
int: lb_x3 = 0;

% Upper bounds to keep the model bounded
% From x1 + 2*x2 <= 2000 => x1 <= 2000, x2 <= 1000
int: ub_x1 = rhs1;
int: ub_x2 = rhs1 div 2;

% No tight upper bound for x3 follows from constraints; use a safe cap
int: ub_x3 = rhs1;


% Variables
% Resource allocation (integer units) to each project
var lb_x1..ub_x1: x1;
var lb_x2..ub_x2: x2;
var lb_x3..ub_x3: x3;

% Total cost to minimize
var int: total_cost;


% Constraints
%--- Resource-allocation feasibility constraints (given operational limits) ---
constraint x1 + 2 * x2 <= rhs1;      % x1 + 2*x2 <= 2000
constraint 3 * x1 + 4 * x3 >= rhs2;  % 3*x1 + 4*x3 >= 1000
constraint x2 - 5 * x3 <= rhs3;      % x2 - 5*x3 <= 500

%--- Cost aggregation (links decision variables to total cost) ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;