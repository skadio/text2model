% Parameters
int: cap_a1 = 10;
int: cap_a2 = 15;
int: cap_rhs = 2000;

int: prod_a1 = 12;
int: prod_a2 = 6;
int: prod_rhs = 800;

int: bal_rhs = 100;

int: cost1 = 50;
int: cost2 = 75;

% Variables
var 0..100000: X1;
var 0..100000: X2;

% Constraints
constraint cap_a1 * X1 + cap_a2 * X2 <= cap_rhs;

constraint prod_a1 * X1 + prod_a2 * X2 >= prod_rhs;

% X1 - 0.5*X2 <= 100  <=>  2*X1 - X2 <= 200
constraint 2 * X1 - X2 <= 2 * bal_rhs;

% Objective
solve minimize cost1 * X1 + cost2 * X2;