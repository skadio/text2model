% Parameters (with values embedded)
int: n_types = 2;
set of int: T = 1..n_types;

% 1 = full-time, 2 = part-time
array[T] of int: n_clerks = [5, 4];
array[T] of int: base_hours_per_clerk = [160, 80];
array[T] of int: sales_rate = [5, 2];                 % pairs/hour
array[T] of float: wage = [1.0, 0.6];                 % yuan/hour (regular)
array[T] of float: overtime_wage = [1.5, 0.7];        % yuan/hour (overtime)
float: profit_per_pair = 0.3;

int: sales_target = 5500;

% Preemptive (lexicographic) goal weights: p1 >> p2 >> p3
int: W1 = 1000000;
int: W2 = 1000;
int: W3 = 1;

% Variables
% Total regular hours worked by each type (bounded by full employment cap)
array[T] of var 0..(n_clerks[1]*base_hours_per_clerk[1] + n_clerks[2]*base_hours_per_clerk[2]): reg_hours;

% Total overtime hours by each type (set a safe upper bound)
% Upper bound chosen to allow feasibility; can be increased if needed.
int: OT_UB = 5000;
array[T] of var 0..OT_UB: ot_hours;

% Deviational variables for goal programming
var 0..1000000: d1_minus;  % sales underachievement
var 0..1000000: d1_plus;   % sales overachievement (not penalized)
var 0..1000000: d2_minus;  % underemployment (regular hours below full employment)
var 0..1000000: d2_plus;   % overemployment (not used, but kept for balance)

% Derived totals
var 0..1000000: total_sales;
var 0..1000000: total_ot;

% Constraints
constraint
  forall(t in T)(
    reg_hours[t] <= n_clerks[t] * base_hours_per_clerk[t]
  );

% Total sales (pairs) produced
constraint
  total_sales = sum(t in T)(sales_rate[t] * (reg_hours[t] + ot_hours[t]));

% Total overtime
constraint
  total_ot = sum(t in T)(ot_hours[t]);

% Goal p1: achieve monthly sales of 5500 pairs (penalize only shortfall)
constraint
  total_sales + d1_minus - d1_plus = sales_target;

% Goal p2: full employment of all sales clerks (use all regular hours available)
int: total_base_hours = sum(t in T)(n_clerks[t] * base_hours_per_clerk[t]);
constraint
  sum(t in T)(reg_hours[t]) + d2_minus - d2_plus = total_base_hours;

% Objective
% Preemptive/lexicographic goal programming via large weights:
% 1) minimize sales shortfall, then 2) minimize underemployment, then 3) minimize overtime
solve minimize W1 * d1_minus + W2 * d2_minus + W3 * total_ot;