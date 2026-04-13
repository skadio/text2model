% Company production planning with cash and machine-hour limits (LP as MIP with integer units)

% Parameters
int: machine_hours_available = 20000;
int: extra_machine_hours = 2000;
int: repair_cost_dollars = 400;

int: mh_per_unit_p1 = 3;
int: mh_per_unit_p2 = 4;

int: cash_available_dollars = 4000;

int: prod_cost_p1_dollars = 3;
int: prod_cost_p2_dollars = 2;

% Work in cents to keep all money integer
int: SC = 100;

int: sp1 = 600;   % $6.00 in cents
int: sp2 = 540;   % $5.40 in cents

% Fractions of revenue available as operating cash (45% and 30%)
% Represent as rational numbers to avoid floating point: 45/100 and 30/100
int: rf1_num = 45; int: rf1_den = 100;
int: rf2_num = 30; int: rf2_den = 100;

% Derived parameters in cents
int: cash_available = cash_available_dollars * SC;
int: repair_cost = repair_cost_dollars * SC;
int: pc1 = prod_cost_p1_dollars * SC;
int: pc2 = prod_cost_p2_dollars * SC;

% Variables
var 0..1000000: x1;          % units of product 1
var 0..1000000: x2;          % units of product 2
var 0..1: y;                 % 1 if repairs are done (buy extra machine hours), else 0
var int: net_income_cents;

% Constraints

% Machine capacity
constraint mh_per_unit_p1 * x1 + mh_per_unit_p2 * x2
        <= machine_hours_available + extra_machine_hours * y;

% Cash availability during period:
% cash_available + 0.45*revenue1 + 0.30*revenue2 - repair_cost*y >= production_costs
% Multiply by lcm(denominators)=100 to keep integer arithmetic:
constraint
  100 * cash_available
+ rf1_num * (sp1 * x1)
+ rf2_num * (sp2 * x2)
- 100 * repair_cost * y
>= 100 * (pc1 * x1 + pc2 * x2);

% Net income (profit) in cents: full revenue - production costs - repair cost (if any)
constraint
  net_income_cents =
    (sp1 * x1 + sp2 * x2)
  - (pc1 * x1 + pc2 * x2)
  - repair_cost * y;

solve maximize net_income_cents;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "repairs(y) = ", show(y), "\n",
  "net_income_cents = ", show(net_income_cents), "\n",
  "net_income_dollars = ", show(net_income_cents div 100), "\n"
];