% Parameters (with values embedded)
int: nProd = 2;
set of int: P = 1..nProd;

array[P] of int: machine_hours_per_unit = [3, 4];
int: machine_hours_available = 20000;

array[P] of float: prod_cost = [3.0, 2.0];
array[P] of float: sell_price = [6.0, 5.40];

float: cash_available = 4000.0;
array[P] of float: revenue_finance_fraction = [0.45, 0.30];

int: extra_machine_hours = 2000;
float: repair_cost = 400.0;

% Variables
array[P] of var float: x;              % units produced/sold
var 0.0..1.0: y;                       % 1 if repair is done, 0 otherwise
var float: net_income;

% Constraints
constraint forall(p in P)(x[p] >= 0.0);

% Machine capacity (can be increased by repair decision y)
constraint sum(p in P)(machine_hours_per_unit[p] * x[p])
          <= machine_hours_available + extra_machine_hours * y;

% Cash availability: production costs must be covered by initial cash plus
% the fraction of sales revenue that becomes available during the period,
% minus repair cost if repair is done.
constraint sum(p in P)(prod_cost[p] * x[p])
          <= cash_available
             + sum(p in P)(revenue_finance_fraction[p] * sell_price[p] * x[p])
             - repair_cost * y;

% Define net income (profit after production costs and repair cost)
constraint net_income
          = sum(p in P)((sell_price[p] - prod_cost[p]) * x[p]) - repair_cost * y;

% Objective
solve maximize net_income;

output [
  "x1=", show(x[1]), "\n",
  "x2=", show(x[2]), "\n",
  "repair=", show(y), "\n",
  "max_net_income=", show(net_income), "\n",
  "max_net_income_rounded=", show(round(net_income)), "\n"
];