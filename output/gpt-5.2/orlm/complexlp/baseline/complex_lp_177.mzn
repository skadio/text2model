% Linear program: maximize net income with cash and machine-hour constraints.
% Data embedded directly.

int: machine_hours_available = 20000;
int: extra_machine_hours = 2000;

float: repair_cost = 400.0;

float: mh1 = 3.0;
float: mh2 = 4.0;

float: cost1 = 3.0;
float: cost2 = 2.0;

float: price1 = 6.0;
float: price2 = 5.40;

float: cash_available = 4000.0;

float: rev_frac1 = 0.45;
float: rev_frac2 = 0.30;

% Decision variables: production quantities (continuous, nonnegative)
var float: x1 >= 0.0;
var float: x2 >= 0.0;

% Decision variable: whether to do repairs (increase machine hours)
var 0..1: y;

% Machine capacity
constraint mh1 * x1 + mh2 * x2 <= machine_hours_available + extra_machine_hours * int2float(y);

% Cash availability (costs must be covered by initial cash plus available portion of revenues)
constraint cost1 * x1 + cost2 * x2 + repair_cost * int2float(y)
        <= cash_available + rev_frac1 * price1 * x1 + rev_frac2 * price2 * x2;

% Objective: net income = total revenue - production costs - repair cost
var float: net_income =
    price1 * x1 + price2 * x2
  - cost1 * x1 - cost2 * x2
  - repair_cost * int2float(y);

solve maximize net_income;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "repairs(y) = ", show(y), "\n",
  "net_income = ", show(net_income), "\n",
  "net_income_rounded = ", show(round(net_income)), "\n"
];