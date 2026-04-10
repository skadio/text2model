% Linear programming model (continuous variables) for product mix with cash and machine-hour constraints.
% All data embedded as requested.

% Decision variables: units produced/sold of products 1 and 2
var float: x1 >= 0.0;
var float: x2 >= 0.0;

% Data
float: mh1 = 3.0;          % machine hours per unit of product 1
float: mh2 = 4.0;          % machine hours per unit of product 2
float: MH0 = 20000.0;      % base machine hours available
float: dMH = 2000.0;       % additional machine hours if repairs done
float: repairCost = 400.0; % cost to get additional hours

float: c1 = 3.0;           % production cost per unit (cash outlay)
float: c2 = 2.0;

float: p1 = 6.0;           % selling price per unit
float: p2 = 5.40;

float: cash0 = 4000.0;     % initial cash available for operations
float: frac1 = 0.45;       % fraction of product 1 revenue available as cash this period
float: frac2 = 0.30;       % fraction of product 2 revenue available as cash this period

% Decision: whether to do repairs (0/1)
var 0..1: y;

% Constraints
% Machine capacity (can increase by 2000 hours if repair is done)
constraint mh1 * x1 + mh2 * x2 <= MH0 + dMH * int2float(y);

% Cash availability: production costs plus (if chosen) repair cost must be covered by initial cash
% plus the usable fraction of sales revenues during the period.
constraint c1 * x1 + c2 * x2 + repairCost * int2float(y)
        <= cash0 + frac1 * p1 * x1 + frac2 * p2 * x2;

% Objective: maximize net income (profit) = revenues - production costs - repair cost
var float: netIncome =
    (p1 * x1 + p2 * x2) - (c1 * x1 + c2 * x2) - repairCost * int2float(y);

solve maximize netIncome;

output [
  "x1 = ", show(x1), "\n",
  "x2 = ", show(x2), "\n",
  "repair y = ", show(y), "\n",
  "netIncome = ", show(netIncome), "\n",
  "netIncomeRounded = ", show(round(netIncome)), "\n"
];