% Parameters
int: n_products = 2;

set of int: P = 1..n_products;

array[P] of float: assembly_hours = [1.0/4.0, 1.0/3.0];
array[P] of float: testing_hours  = [1.0/8.0, 1.0/3.0];
array[P] of float: raw_cost       = [1.2, 0.9];
array[P] of float: market_value   = [9.0, 8.0];

float: assembly_regular_max = 90.0;
float: testing_max         = 80.0;

float: overtime_max        = 50.0;
float: overtime_cost_per_h = 9.0;

% Use scaling to convert fractional hours and costs to integers (exactly)
int: scale = 120; % LCM to make all coefficients integral (hours and $)
array[P] of int: a_asm = [round(assembly_hours[p] * scale) | p in P];
array[P] of int: a_tst = [round(testing_hours[p]  * scale) | p in P];
array[P] of int: a_raw = [round(raw_cost[p]       * scale) | p in P];
array[P] of int: a_val = [round(market_value[p]   * scale) | p in P];

int: ASM_REG_MAX = round(assembly_regular_max * scale);
int: TST_MAX     = round(testing_max * scale);
int: OT_MAX      = round(overtime_max * scale);
int: OT_COST     = round(overtime_cost_per_h * scale);

% Variables
array[P] of var 0..100000: x;        % units produced of each product (unbounded upper, but integer)
var 0..OT_MAX: ot_asm;               % overtime assembly used (scaled hours)

var int: profit_scaled;              % objective in scaled dollars (integer)

% Constraints
constraint
  sum(p in P)(a_asm[p] * x[p]) <= ASM_REG_MAX + ot_asm;

constraint
  sum(p in P)(a_tst[p] * x[p]) <= TST_MAX;

constraint
  profit_scaled =
    sum(p in P)((a_val[p] - a_raw[p]) * x[p]) - OT_COST * ot_asm div scale;

% Objective
solve maximize profit_scaled;