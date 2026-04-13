% Parameters (with values embedded)
int: risk1 = 2;
int: risk2 = 3;
int: risk3 = 4;

int: min_return = 1500;
int: max_diff = 200;
int: eq_balance = 400;

% Variables
var int: X1;
var int: X2;
var int: X3;

% Constraints
% (Bounds were mentioned but not specified numerically in the description; thus only integrality is enforced.)
constraint 5*X1 + 7*X2 + 8*X3 >= min_return;

% X1 - (3/4)X2 - (1/2)X3 <= 200  ->  4*X1 - 3*X2 - 2*X3 <= 800
constraint 4*X1 - 3*X2 - 2*X3 <= 4*max_diff;

% 2*X2 - X1 - X3 == 400
constraint 2*X2 - X1 - X3 = eq_balance;

% Objective
var int: total_risk = risk1*X1 + risk2*X2 + risk3*X3;
solve minimize total_risk;