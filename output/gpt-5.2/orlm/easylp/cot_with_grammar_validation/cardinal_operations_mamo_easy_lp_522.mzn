% Parameters
int: risk_X1 = 2;
int: risk_X2 = 3;
int: risk_X3 = 4;

int: min_return = 1500;

int: diff_limit = 200;

int: eq_rhs = 400;

% Variables
var int: X1;
var int: X2;
var int: X3;

var int: total_risk;

% Constraints
constraint 5*X1 + 7*X2 + 8*X3 >= min_return;

% (X1 - 3/4 X2 - 1/2 X3) <= 200  ->  4*X1 - 3*X2 - 2*X3 <= 800
constraint 4*X1 - 3*X2 - 2*X3 <= 4*diff_limit;

% 2*X2 - X1 - X3 = 400
constraint 2*X2 - X1 - X3 = eq_rhs;

% Non-negativity (bounds not otherwise specified in the description)
constraint X1 >= 0;
constraint X2 >= 0;
constraint X3 >= 0;

constraint total_risk = risk_X1*X1 + risk_X2*X2 + risk_X3*X3;

% Objective
solve minimize total_risk;