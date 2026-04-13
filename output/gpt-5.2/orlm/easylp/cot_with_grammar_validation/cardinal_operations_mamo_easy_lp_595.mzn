% Parameters
int: cost1 = 4;
int: cost2 = 5;
int: cost3 = 6;
int: cost4 = 7;

int: ub12 = 1000;
int: lb23 = 800;
int: diff34 = 200;
int: ub_half4_minus1 = 300;

int: lb_x = 0;
int: ub_x = 10000;

% Variables
var lb_x..ub_x: x1;
var lb_x..ub_x: x2;
var lb_x..ub_x: x3;
var lb_x..ub_x: x4;

var int: total_cost;

% Constraints
constraint x1 + x2 <= ub12;
constraint x2 + x3 >= lb23;
constraint x3 - x4 = diff34;

% (x4/2) - x1 <= 300  <=>  x4 - 2*x1 <= 600  (avoid fractions)
constraint x4 - 2 * x1 <= 2 * ub_half4_minus1;

constraint total_cost = cost1 * x1 + cost2 * x2 + cost3 * x3 + cost4 * x4;

% Objective
solve minimize total_cost;