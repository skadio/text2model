% Parameters
int: n_products = 2;

set of int: P = 1..n_products;

array[P] of int: machine_hours_per_unit = [3, 4];
int: machine_hours_available_base = 20000;
int: extra_machine_hours = 2000;

array[P] of float: unit_cost = [3.0, 2.0];
array[P] of float: unit_price = [6.0, 5.40];

float: cash_available = 4000.0;

array[P] of float: revenue_available_fraction = [0.45, 0.30];

float: repair_cost = 400.0;

% Variable bounds helpers
int: x_ub1 = (machine_hours_available_base + extra_machine_hours) div machine_hours_per_unit[1];
int: x_ub2 = (machine_hours_available_base + extra_machine_hours) div machine_hours_per_unit[2];
int: x_ub = max(x_ub1, x_ub2);

int: max_profit_per_unit_int = ceil(max([unit_price[p] - unit_cost[p] | p in P]));
int: profit_ub_int = (machine_hours_available_base + extra_machine_hours) * max_profit_per_unit_int;

% Variables
array[P] of var 0..x_ub: x;                 % units produced/sold of each product (integer units)
var bool: do_repair;                        % 1 if repairs are done to gain extra hours

var int: net_income_int;                    % objective in dollars (rounded to nearest)

% Constraints
constraint
  sum(p in P)(machine_hours_per_unit[p] * x[p])
  <= machine_hours_available_base + extra_machine_hours * bool2int(do_repair);

constraint
  sum(p in P)(unit_cost[p] * int2float(x[p])) + repair_cost * bool2int(do_repair)
  <= cash_available
     + sum(p in P)(revenue_available_fraction[p] * unit_price[p] * int2float(x[p]));

constraint
  net_income_int = round(
    sum(p in P)((unit_price[p] - unit_cost[p]) * int2float(x[p]))
    - repair_cost * bool2int(do_repair)
  );

constraint net_income_int >= -100000000;
constraint net_income_int <= profit_ub_int;

% Objective
solve maximize net_income_int;