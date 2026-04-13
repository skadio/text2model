% Parameters (with values embedded)
int: cost1 = 10;
int: cost2 = 20;
int: cost3 = 30;

int: rhs1 = 2000;  % X1 + 2*X2 <= 2000
int: rhs2 = 1000;  % 3*X1 + 4*X3 >= 1000
int: rhs3 = 500;   % X2 - 5*X3 <= 500

% Since the description mentions "specific bounds" but does not provide them,
% we use safe nonnegative bounds and add explicit upper bounds derived from constraints.
int: U1 = 2000;  % from X1 + 2*X2 <= 2000 with X2 >= 0
int: U2 = 1000;  % from X1 + 2*X2 <= 2000 with X1 >= 0 => X2 <= 1000
int: U3 = 1000;  % loose safe upper bound

% Variables
var 0..U1: X1;
var 0..U2: X2;
var 0..U3: X3;

var 0..(cost1*U1 + cost2*U2 + cost3*U3): TotalCost;

% Constraints
constraint X1 + 2*X2 <= rhs1;
constraint 3*X1 + 4*X3 >= rhs2;
constraint X2 - 5*X3 <= rhs3;

constraint TotalCost = cost1*X1 + cost2*X2 + cost3*X3;

% Objective
solve minimize TotalCost;