% Parameters
% -----------------------
% Staff counts
int: n_full_time = 5;                 % number of full-time clerks
int: n_part_time = 4;                 % number of part-time clerks

% Regular monthly working hours per clerk
int: reg_hours_full = 160;            % full-time regular hours
int: reg_hours_part = 80;             % part-time regular hours

% Productivity (pairs sold per hour)
int: rate_full = 5;                   % full-time sales rate
int: rate_part = 2;                   % part-time sales rate

% Wages (yuan per hour)
float: wage_full = 1.0;               % full-time regular wage
float: wage_part = 0.6;               % part-time regular wage

% Overtime pay (yuan per hour)
float: ot_wage_full = 1.5;            % full-time overtime pay
float: ot_wage_part = 0.7;            % part-time overtime pay

% Profit per pair sold
float: profit_per_pair = 0.3;         % yuan per pair

% Goal targets
int: target_sales = 5500;             % monthly sales goal (pairs)

% A practical upper bound on overtime hours (per clerk, per month)
% (Not provided explicitly; set to a reasonable value to ensure bounded vars.)
int: max_ot_per_clerk = 200;

% Derived totals (regular capacity)
int: total_reg_hours_full = n_full_time * reg_hours_full;
int: total_reg_hours_part = n_part_time * reg_hours_part;


% Variables
% -----------------------
% Overtime hours used by each group (aggregated)
var 0..(n_full_time * max_ot_per_clerk): ot_hours_full;   % total full-time overtime hours
var 0..(n_part_time * max_ot_per_clerk): ot_hours_part;   % total part-time overtime hours

% Total hours worked (regular + overtime) per group
var int: total_hours_full;                                  % total full-time hours
var int: total_hours_part;                                  % total part-time hours

% Total sales volume (pairs) produced in the month
var 0..100000: total_sales_pairs;                            % total pairs sold

% Profit and labor cost (for reporting/optimization if needed)
var float: total_revenue;                                    % profit revenue from sales
var float: total_labor_cost;                                 % wages + overtime pay cost

% Goal-deviation variables (goal programming style)
% p1: sales target deviation
var 0..100000: sales_shortfall;                              % underachievement of sales goal
var 0..100000: sales_excess;                                 % overachievement of sales goal (optional)

% p2: full employment (regular hours should be fully used; deviation should be 0)
var 0..(total_reg_hours_full + total_reg_hours_part): under_employment_hours; % unused regular hours
var 0..(total_reg_hours_full + total_reg_hours_part): over_employment_hours;  % exceeding regular hours via overtime (tracks for goal)

% p3: overtime minimization helper
var 0..(n_full_time * max_ot_per_clerk + n_part_time * max_ot_per_clerk): total_overtime_hours; % total overtime


% Constraints
% -----------------------

% -------------------------------------------------------------------
% Working hours accounting (regular + overtime)
% -------------------------------------------------------------------
constraint
  total_hours_full = total_reg_hours_full + ot_hours_full;
constraint
  total_hours_part = total_reg_hours_part + ot_hours_part;

% -------------------------------------------------------------------
% Sales volume production from worked hours
% -------------------------------------------------------------------
constraint
  total_sales_pairs = rate_full * total_hours_full + rate_part * total_hours_part;

% -------------------------------------------------------------------
% Profit revenue and labor cost accounting (for reporting/optimization)
% -------------------------------------------------------------------
constraint
  total_revenue = profit_per_pair * int2float(total_sales_pairs);

constraint
  total_labor_cost =
      wage_full * int2float(total_reg_hours_full)
    + wage_part * int2float(total_reg_hours_part)
    + ot_wage_full * int2float(ot_hours_full)
    + ot_wage_part * int2float(ot_hours_part);

% -------------------------------------------------------------------
% Goal p1: sales target achievement (deviation variables)
% total_sales_pairs + shortfall - excess = target
% -------------------------------------------------------------------
constraint
  total_sales_pairs + sales_shortfall - sales_excess = target_sales;

% -------------------------------------------------------------------
% Goal p2: full employment of all clerks (regular-hours utilization)
% Total worked hours deviates from total regular hours via under/over variables.
% total_worked + under - over = total_regular
% -------------------------------------------------------------------
constraint
  (total_hours_full + total_hours_part)
  + under_employment_hours - over_employment_hours
  =
  (total_reg_hours_full + total_reg_hours_part);

% Link over-employment to overtime (since over regular hours come from overtime)
constraint
  over_employment_hours = ot_hours_full + ot_hours_part;

% -------------------------------------------------------------------
% Goal p3: total overtime hours helper variable
% -------------------------------------------------------------------
constraint
  total_overtime_hours = ot_hours_full + ot_hours_part;


% Objective
% -----------------------
solve minimize
  % Preemptive/lexicographic goal programming priorities:
  % p1: minimize sales shortfall (meet at least 5500 pairs)
  % p2: minimize under-employment of regular hours (full employment)
  % p3: minimize total overtime hours
  lex2(
    sales_shortfall,
    lex2(under_employment_hours, total_overtime_hours)
  );