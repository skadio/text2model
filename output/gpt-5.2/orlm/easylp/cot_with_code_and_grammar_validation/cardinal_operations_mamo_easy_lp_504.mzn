% Parameters
int: maxX1 = 5000;
int: maxX2 = 4000;
int: maxX3 = 3000;
int: maxTotal = 10000;

int: minEffect = 2000;
int: maxBalanceDiff = 1500;

int: c1 = 5000;
int: c2 = 3000;
int: c3 = 7000;

% Use integer-scaled coefficients to avoid fractions:
% Effectiveness: 2*X1 - 3*X2 + 4.5*X3 >= 2000  ==>  4*X1 - 6*X2 + 9*X3 >= 4000
% Balance: |0.5*X2 - X1 - 0.75*X3| <= 1500  ==>  |2*X2 - 4*X1 - 3*X3| <= 6000
int: eff_a1 = 4;
int: eff_a2 = -6;
int: eff_a3 = 9;
int: eff_rhs = 4000;

int: bal_b1 = -4;
int: bal_b2 = 2;
int: bal_b3 = -3;
int: bal_rhs = 6000;

% Variables
var 0..maxX1: X1;
var 0..maxX2: X2;
var 0..maxX3: X3;

var 0..(c1*maxX1 + c2*maxX2 + c3*maxX3): total_cost;

% Constraints
constraint X1 + X2 + X3 <= maxTotal;

constraint eff_a1*X1 + eff_a2*X2 + eff_a3*X3 >= eff_rhs;

constraint abs(bal_b1*X1 + bal_b2*X2 + bal_b3*X3) <= bal_rhs;

constraint total_cost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize total_cost;