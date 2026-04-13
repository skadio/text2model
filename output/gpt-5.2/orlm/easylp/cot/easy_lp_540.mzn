% Parameters (with values embedded)
int: cost1 = 500;
int: cost2 = 700;
int: cost3 = 900;

int: max_total_alloc = 10;

int: c2_a1 = 5;
int: c2_a2 = 4;
int: c2_rhs = 30;

int: c3_a1 = 7;
int: c3_a3 = 6;
int: c3_rhs = 20;

% Variables
var 0..max_total_alloc: X1;
var 0..max_total_alloc: X2;
var 0..max_total_alloc: X3;

var int: total_cost;

% Constraints
constraint X1 + X2 + X3 <= max_total_alloc;

constraint c2_a1 * X1 + c2_a2 * X2 >= c2_rhs;

constraint c3_a1 * X1 - c3_a3 * X3 <= c3_rhs;

constraint X2 - (X1 + X3) >= 0;

constraint total_cost = cost1 * X1 + cost2 * X2 + cost3 * X3;

% Objective
solve minimize total_cost;