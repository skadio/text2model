% Parameters (with values embedded)
int: c1 = 2;
int: c2 = 3;
int: c3 = 4;

int: ub12 = 1000;   % x1 + 2*x2 <= 1000
int: diff13 = 300;  % 3*x1 >= x3 + 300
int: ub23 = 1500;   % 4*x2 + x3 <= 1500
int: ub_diff = 70;  % 5*x2 - (x1 + x3) <= 70

% NOTE: The problem statement mentions "specific bounds" for x1,x2,x3
% but does not provide numeric lower/upper bounds. We enforce nonnegativity.
int: lb = 0;

% Variables
var int: x1;
var int: x2;
var int: x3;

% Constraints
constraint x1 >= lb /\ x2 >= lb /\ x3 >= lb;

constraint x1 + 2*x2 <= ub12;
constraint 3*x1 >= x3 + diff13;
constraint 4*x2 + x3 <= ub23;
constraint 5*x2 - (x1 + x3) <= ub_diff;

% Objective
var int: total_cost = c1*x1 + c2*x2 + c3*x3;
solve minimize total_cost;