% Parameters
%--------------------------------------------------------------------
% Product set
%--------------------------------------------------------------------
int: nProducts = 2;
set of int: PRODUCTS = 1..nProducts;

% Machine hours required per unit for each product
array[PRODUCTS] of int: machine_hours_per_unit = [3, 4];

% Available machine hours (base) and optional increase
int: machine_hours_available = 20000;
int: extra_machine_hours = 2000;

% Repair cost to unlock extra machine hours (dollars)
int: repair_cost = 400;

% Unit production costs for each product (dollars)
array[PRODUCTS] of int: unit_cost = [3, 2];

% Unit selling prices for each product (cents, to keep linear integer arithmetic)
array[PRODUCTS] of int: unit_price_cents = [600, 540];

% Fraction of sales revenue available during current period (percent as integer)
array[PRODUCTS] of int: revenue_available_percent = [45, 30];

% Initial available cash (dollars)
int: cash_available = 4000;


% Variables
%--------------------------------------------------------------------
% Units produced/sold of each product (nonnegative)
% Upper bound 20000 is safe due to machine capacity (3 hrs/unit min => <= ~7333 without extra)
%--------------------------------------------------------------------
array[PRODUCTS] of var 0..20000: x_units;

% Whether to perform repairs to gain extra machine hours
var 0..1: do_repairs;

% Net income in cents
var int: net_income_cents;


% Constraints
%--------------------------------------------------------------------
% Machine capacity constraint (base hours + optional extra hours)
%--------------------------------------------------------------------
constraint
  sum(p in PRODUCTS)(machine_hours_per_unit[p] * x_units[p])
  <= machine_hours_available + extra_machine_hours * do_repairs;

%--------------------------------------------------------------------
% Cash availability constraint:
% Initial cash + portion of current-period revenues finances production costs + repairs
% LHS/RHS both in cents:
%   - Costs and cash are dollars scaled by 100
%   - Available revenue is (percent * price_cents * units)
%--------------------------------------------------------------------
constraint
  100 * sum(p in PRODUCTS)(unit_cost[p] * x_units[p]) + 100 * repair_cost * do_repairs
  <= 100 * cash_available
     + sum(p in PRODUCTS)(revenue_available_percent[p] * unit_price_cents[p] * x_units[p]);

%--------------------------------------------------------------------
% Net income definition (in cents):
% Full revenues - production costs - repair cost
%--------------------------------------------------------------------
constraint
  net_income_cents =
    sum(p in PRODUCTS)(unit_price_cents[p] * x_units[p])
    - 100 * sum(p in PRODUCTS)(unit_cost[p] * x_units[p])
    - 100 * repair_cost * do_repairs;


% Objective
solve maximize net_income_cents;