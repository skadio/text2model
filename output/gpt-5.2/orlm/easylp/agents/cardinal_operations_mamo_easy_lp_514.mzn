% Parameters
% Unit production costs
int: cost_x1 = 2;
int: cost_x2 = 3;
int: cost_x3 = 4;

% Constraint coefficients / RHS values (embedded from description)
int: rhs_c1 = 1000;   % x1 + 2*x2 <= 1000
int: gap_c2 = 300;    % 3*x1 - x3 >= 300
int: rhs_c3 = 1500;   % 4*x2 + x3 <= 1500
int: rhs_c4 = 70;     % 5*x2 - x1 - x3 <= 70

% NOTE: The description mentions "specific bounds" but does not provide numeric bounds,
% so only implied non-negativity and safe upper bounds derived from constraints are used.


% Variables
var 0..rhs_c1: x1;                  % units of product x1 (integer, non-negative)
var 0..(rhs_c1 div 2): x2;          % from x1 + 2*x2 <= 1000 => x2 <= 500
var 0..rhs_c3: x3;                  % safe bound from 4*x2 + x3 <= 1500 => x3 <= 1500

% Upper bound for total_cost based on variable bounds above (safe, not necessarily tight)
var 0..(cost_x1*rhs_c1 + cost_x2*(rhs_c1 div 2) + cost_x3*rhs_c3): total_cost;


% Constraints
% Link total_cost to the linear production cost expression
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Capacity constraint c1: combined production limit for x1 and 2*x2
constraint
  x1 + 2 * x2 <= rhs_c1;

% Relationship constraint c2: 3*x1 must exceed x3 by at least 300 units
constraint
  3 * x1 - x3 >= gap_c2;

% Capacity constraint c3: combined production limit for 4*x2 and x3
constraint
  4 * x2 + x3 <= rhs_c3;

% Difference constraint c4: 5*x2 - (x1 + x3) must not surpass 70 units
constraint
  5 * x2 - x1 - x3 <= rhs_c4;


% Objective
solve minimize total_cost;