% Parameters
int: hours_avail_base = 20000;
int: hours_increase = 2000;
int: repair_cost = 400;

int: cash_avail = 4000;

int: h1 = 3;
int: h2 = 4;

int: cost1 = 3;
int: cost2 = 2;

/* Use cents to keep linear integer arithmetic */
int: price1_c = 600;   % $6.00
int: price2_c = 540;   % $5.40

/* Financing fractions as exact rational multipliers over cents */
int: fin1_num = 45; int: fin1_den = 100;   % 45%
int: fin2_num = 30; int: fin2_den = 100;   % 30%

% Variables
var 0..1000000: x1;                 % units of product 1
var 0..1000000: x2;                 % units of product 2
var 0..1: repair;                   % 1 if repairs are done to gain extra hours

var 0..1000000000: revenue_c;       % total revenue (cents)
var 0..1000000000: financed_c;      % revenue made available for operations (cents)
var 0..1000000000: cost_total_c;    % production + repair cost (cents)
var 0..1000000000: net_income_c;    % net income (cents)

% Constraints
constraint
  h1 * x1 + h2 * x2 <= hours_avail_base + hours_increase * repair;

constraint
  revenue_c = price1_c * x1 + price2_c * x2;

constraint
  financed_c * fin1_den = fin1_num * price1_c * x1 + fin2_num * price2_c * x2;

constraint
  cost_total_c = 100 * (cost1 * x1 + cost2 * x2 + repair_cost * repair);

constraint
  cost_total_c <= 100 * cash_avail + financed_c;

constraint
  net_income_c = revenue_c - cost_total_c;

% Objective
solve maximize net_income_c;