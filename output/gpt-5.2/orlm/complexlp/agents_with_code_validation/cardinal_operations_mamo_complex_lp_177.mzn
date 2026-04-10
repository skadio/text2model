% Parameters
% Machine-hours required per unit of product 1 and 2
int: hours_p1 = 3;
int: hours_p2 = 4;

% Machine-hours available initially and optional increase
int: machine_hours_base = 20000;
int: machine_hours_extra = 2000;

% Fixed repair cost to unlock extra machine hours
int: repair_cost = 400;

% Unit production costs (in dollars; converted to cents in constraints)
int: cost_p1 = 3;
int: cost_p2 = 2;

% Unit selling prices (cents)
int: price_p1_cents = 600;   % $6.00
int: price_p2_cents = 540;   % $5.40

% Initial available cash (cents)
int: cash0_cents = 400000;   % $4,000

% Fraction of sales revenue available during current period (exact rationals)
int: rev_share_p1_num = 45; int: rev_share_p1_den = 100;  % 45%
int: rev_share_p2_num = 30; int: rev_share_p2_den = 100;  % 30%

% Upper bounds for production (bounded by max possible machine hours)
int: max_x1 = (machine_hours_base + machine_hours_extra) div hours_p1;
int: max_x2 = (machine_hours_base + machine_hours_extra) div hours_p2;


% Variables
% Units produced of product 1 and 2
var 0..max_x1: x1;
var 0..max_x2: x2;

% Whether to perform repairs to gain extra machine hours
var bool: do_repairs;

% Total machine hours used
var 0..(machine_hours_base + machine_hours_extra): machine_hours_used;

% Total cash spent on production + repairs (cents)
var 0..(cash0_cents + price_p1_cents * max_x1 + price_p2_cents * max_x2): cash_spent_cents;

% Sales revenue (cents)
var 0..(price_p1_cents * max_x1 + price_p2_cents * max_x2): revenue_cents;

% Portion of revenue available as additional operating cash during the period (cents)
var 0..(price_p1_cents * max_x1 + price_p2_cents * max_x2): available_revenue_cents;

% Net income (cents)
var int: net_income_cents;


% Constraints

%--- Machine capacity accounting and limit (with optional repairs) ---
constraint
  machine_hours_used = hours_p1 * x1 + hours_p2 * x2;

constraint
  machine_hours_used <= machine_hours_base + (if do_repairs then machine_hours_extra else 0 endif);

%--- Revenue and available-in-period revenue (cash inflow) accounting ---
constraint
  revenue_cents = price_p1_cents * x1 + price_p2_cents * x2;

% Use exact rational shares; ensure integrality via divisibility constraints
constraint
  available_revenue_cents =
    (rev_share_p1_num * price_p1_cents * x1) div rev_share_p1_den
  + (rev_share_p2_num * price_p2_cents * x2) div rev_share_p2_den;

constraint (rev_share_p1_num * price_p1_cents * x1) mod rev_share_p1_den = 0;
constraint (rev_share_p2_num * price_p2_cents * x2) mod rev_share_p2_den = 0;

%--- Cash spent accounting (production costs + optional repair cost) ---
constraint
  cash_spent_cents =
    100 * cost_p1 * x1
  + 100 * cost_p2 * x2
  + (if do_repairs then 100 * repair_cost else 0 endif);

%--- Cash availability constraint (initial cash + available revenue finances spending) ---
constraint
  cash_spent_cents <= cash0_cents + available_revenue_cents;

%--- Net income definition (profit = total revenue - cash spent) ---
constraint
  net_income_cents = revenue_cents - cash_spent_cents;


% Objective
solve maximize net_income_cents;