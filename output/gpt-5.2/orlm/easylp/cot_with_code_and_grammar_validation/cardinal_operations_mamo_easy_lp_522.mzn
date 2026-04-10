% Parameters
int: risk_x1 = 2;
int: risk_x2 = 3;
int: risk_x3 = 4;

int: min_return = 1500;

int: diff_limit = 200;

int: eq_rhs = 400;

% (No explicit bounds were provided in the description; keep investments non-negative.)
int: lb_x1 = 0;
int: lb_x2 = 0;
int: lb_x3 = 0;

% Big-M upper bounds to keep variables bounded (since explicit bounds are missing)
int: ub_x1 = 100000;
int: ub_x2 = 100000;
int: ub_x3 = 100000;

% Variables
var lb_x1..ub_x1: X1;
var lb_x2..ub_x2: X2;
var lb_x3..ub_x3: X3;

var 0..(risk_x1*ub_x1 + risk_x2*ub_x2 + risk_x3*ub_x3): total_risk;

% Constraints
constraint
  5*X1 + 7*X2 + 8*X3 >= min_return;

% X1 - (3/4)X2 - (1/2)X3 <= 200
% Multiply by 4 to keep integrality: 4*X1 - 3*X2 - 2*X3 <= 800
constraint
  4*X1 - 3*X2 - 2*X3 <= 4*diff_limit;

% 2*X2 - X1 - X3 == 400
constraint
  2*X2 - X1 - X3 = eq_rhs;

constraint
  total_risk = risk_x1*X1 + risk_x2*X2 + risk_x3*X3;

% Objective
solve minimize total_risk;