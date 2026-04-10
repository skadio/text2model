% Parameters
int: total_fund = 100000;                           % Total available investment in dollars
int: n_portfolios = 4;                              % Number of portfolios
set of int: PORTFOLIOS = 1..n_portfolios;           % Index set for portfolios

array[PORTFOLIOS] of string: portfolio_name = ["X","Y","Z","W"];  % Portfolio labels

array[PORTFOLIOS] of float: fee_rate =              % Annual management fee rates
  [0.05, 0.07, 0.06, 0.09];

array[PORTFOLIOS] of int: min_invest =              % Minimum investment per portfolio (dollars)
  [20000, 15000, 25000, 40000];

% Variables
array[PORTFOLIOS] of var 0..total_fund: invest;     % Investment amounts in whole dollars per portfolio
var float: total_fee;                               % Total annual management fee in dollars (unrounded)
var 0..total_fund: total_fee_rounded;               % Total annual management fee rounded to nearest dollar

% Constraints

% --- Budget allocation constraint: invest the entire available fund ---
constraint
  sum(p in PORTFOLIOS)(invest[p]) = total_fund;

% --- Minimum investment constraints per portfolio (risk/balance requirements) ---
constraint
  forall(p in PORTFOLIOS)(
    invest[p] >= min_invest[p]
  );

% --- Define total annual management fee (unrounded, in dollars) ---
constraint
  total_fee = sum(p in PORTFOLIOS)(
    fee_rate[p] * int2float(invest[p])
  );

% --- Rounding constraint: total_fee_rounded is total_fee rounded to nearest dollar ---
% Nearest-integer rounding via half-up rule: r = floor(x + 0.5)
constraint
  int2float(total_fee_rounded) <= total_fee + 0.5 /\
  total_fee + 0.5 < int2float(total_fee_rounded + 1);

% Objective
solve minimize total_fee_rounded;