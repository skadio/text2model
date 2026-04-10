% Parameters (with values embedded)
int: nProd = 2;
set of int: P = 1..nProd;

% Resource usage per unit (in fractions to keep exact arithmetic)
array[P] of int: asm_num = [1, 1];      % numerators for assembly time
array[P] of int: asm_den = [4, 3];      % denominators for assembly time
array[P] of int: tst_num = [1, 1];      % numerators for testing time
array[P] of int: tst_den = [8, 3];      % denominators for testing time

% Costs/values in dollars, scaled to cents to avoid floats
array[P] of int: value_c = [900, 800];  % $9, $8
array[P] of int: raw_c   = [120,  90];  % $1.2, $0.9

int: asm_regular_max = 90;
int: tst_max = 80;
int: asm_overtime_max = 50;
int: overtime_cost_c_per_hr = 700;      % $7/hour

% Variable upper bounds (safe big-M based on resource limits)
int: x1_max = 360;  % min(floor(90/(1/4)), floor(80/(1/8))) = min(360, 640)
int: x2_max = 240;  % min(floor(90/(1/3)), floor(80/(1/3))) = min(270, 240)

% Variables
array[P] of var 0..max(x1_max, x2_max): x;  % production quantities
var 0..asm_overtime_max: overtime_asm;      % overtime assembly hours
var int: profit_c;                          % profit in cents

% Constraints
constraint x[1] <= x1_max;
constraint x[2] <= x2_max;

% Assembly capacity: regular + overtime (use integer arithmetic by clearing denominators)
% x1*(1/4) + x2*(1/3) <= 90 + overtime
% Multiply by 12: 3*x1 + 4*x2 <= 1080 + 12*overtime
constraint 3 * x[1] + 4 * x[2] <= 12 * asm_regular_max + 12 * overtime_asm;

% Testing capacity
% x1*(1/8) + x2*(1/3) <= 80
% Multiply by 24: 3*x1 + 8*x2 <= 1920
constraint 3 * x[1] + 8 * x[2] <= 24 * tst_max;

% Profit in cents: revenue - raw materials - overtime cost
constraint profit_c =
  sum(p in P)(value_c[p] * x[p]) - sum(p in P)(raw_c[p] * x[p]) - overtime_cost_c_per_hr * overtime_asm;

% Objective
solve maximize profit_c;

output [
  "x1=", show(x[1]), "\n",
  "x2=", show(x[2]), "\n",
  "overtime_asm_hours=", show(overtime_asm), "\n",
  "profit_rounded_dollars=",
    show( (profit_c + 50) div 100 ), "\n"
];