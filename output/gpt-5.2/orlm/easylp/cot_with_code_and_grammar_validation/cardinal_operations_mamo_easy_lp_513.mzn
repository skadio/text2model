% Parameters
int: c1 = 50;
int: c2 = 75;
int: c3 = 120;

int: total_cap = 500;

int: eff_req = 1000;
int: eff_a1 = 5;
int: eff_a2 = 10;

int: diff_cap = 300;

% Use integer form: (5/2)*X3 - X1 <= 300  <=>  5*X3 - 2*X1 <= 600
int: diff_a3 = 5;
int: diff_a1 = -2;
int: diff_rhs = 2 * diff_cap;

% Variables
var 0..total_cap: X1;
var 0..total_cap: X2;
var 0..total_cap: X3;

var 0..(c1*total_cap + c2*total_cap + c3*total_cap): total_cost;

% Constraints
constraint X1 + X2 + X3 <= total_cap;

constraint eff_a1 * X1 + eff_a2 * X2 >= eff_req;

constraint diff_a3 * X3 + diff_a1 * X1 <= diff_rhs;

constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3;

% Objective
solve minimize total_cost;