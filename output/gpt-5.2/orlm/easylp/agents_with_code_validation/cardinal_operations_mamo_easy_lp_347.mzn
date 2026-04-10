% Investment allocation model (all data embedded)

int: total_investment = 10000000;            % Total dollars to allocate
set of int: Projects = 1..4;                 % 1=X, 2=Y, 3=Z, 4=W

% Return rates in percent to keep everything integer
array[Projects] of int: return_pct = [5, 7, 6, 8];

array[Projects] of int: min_invest = [2000000, 0, 1500000, 0];
array[Projects] of int: max_invest = [total_investment, 5000000, total_investment, 3000000];

% Decision variables: whole dollars invested
array[Projects] of var 0..total_investment: invest;

% Total return in dollars is integer because pct/100 * dollars may be fractional,
% so we measure in "cents of percent" units (i.e., dollar * percent) and divide by 100 at the end.
var 0..(total_investment * 8): total_return_dollar_pct;
var 0..(total_investment * 8) div 100 + 1: total_return_rounded;

% Bounds per project
constraint forall(p in Projects) (
  invest[p] >= min_invest[p] /\
  invest[p] <= max_invest[p]
);

% Full allocation
constraint sum(p in Projects)(invest[p]) = total_investment;

% Compute total return in (dollar * percent) units
constraint total_return_dollar_pct = sum(p in Projects)(return_pct[p] * invest[p]);

% Round to nearest dollar: round( total_return_dollar_pct / 100 )
% Using integer arithmetic: round(x/100) = (x + 50) div 100
constraint total_return_rounded = (total_return_dollar_pct + 50) div 100;

solve minimize total_return_rounded;

output [
  "invest_X=", show(invest[1]), "\n",
  "invest_Y=", show(invest[2]), "\n",
  "invest_Z=", show(invest[3]), "\n",
  "invest_W=", show(invest[4]), "\n",
  "min_total_return_rounded=", show(total_return_rounded), "\n"
];