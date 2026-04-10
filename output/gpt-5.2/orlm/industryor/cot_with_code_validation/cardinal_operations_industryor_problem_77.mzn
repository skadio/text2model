% Shoe store goal programming model (embedded data)

% Parameters
int: nF = 5;              % number of full-time clerks
int: nP = 4;              % number of part-time clerks

int: H_F = 160;           % regular monthly hours per full-time clerk
int: H_P = 80;            % regular monthly hours per part-time clerk

int: rF = 5;              % sales rate full-time (pairs/hour)
int: rP = 2;              % sales rate part-time (pairs/hour)

int: target_sales = 5500;

% Goal programming weights (lexicographic-style via weighted sum)
% Use int64 to avoid overflow with large weights/products
int: W1 = 1000000;  % priority for meeting sales target (p1)
int: W2 = 1000;     % priority for full employment (p2) - effectively zero here
int: W3 = 1;        % priority for minimizing overtime (p3)

% Upper bounds for overtime hours (to keep variables bounded)
int: OTmaxF = 200;
int: OTmaxP = 200;

% Variables
var 0..OTmaxF: ot_hours_F;     % overtime hours per full-time clerk (assumed same for all)
var 0..OTmaxP: ot_hours_P;     % overtime hours per part-time clerk (assumed same for all)

var 0..1000000: total_pairs;

% Deviational variables for goals
var 0..1000000: d_sales_under;  % underachievement of sales target
var 0..1000000: d_sales_over;   % overachievement (not penalized)

% p2 deviation (kept for structure; full employment is enforced)
var 0..1000000: d_emp_under;

var 0..(nF*OTmaxF + nP*OTmaxP): total_overtime;

% Constraints
constraint
  total_pairs =
    nF * rF * (H_F + ot_hours_F) +
    nP * rP * (H_P + ot_hours_P);

% p1: achieve monthly sales of 5500 pairs (minimize underachievement)
constraint
  total_pairs + d_sales_under - d_sales_over = target_sales;

% p2: ensure full employment of all sales clerks (use all regular hours)
% In this model we always use all regular hours, so underemployment is zero.
constraint d_emp_under = 0;

% p3: minimize total overtime hours
constraint total_overtime = nF * ot_hours_F + nP * ot_hours_P;

% Objective (use int64 to prevent integer overflow)
solve minimize
  int64(W1) * int64(d_sales_under) +
  int64(W2) * int64(d_emp_under) +
  int64(W3) * int64(total_overtime);