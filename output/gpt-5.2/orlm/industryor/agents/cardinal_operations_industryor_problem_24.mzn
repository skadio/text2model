% Parameters
% Total initial capital (yuan)
int: initial_capital = 100000;

% Investment options count
int: n_options = 2;
set of int: OPTIONS = 1..n_options;

% Planning horizon (years)
int: horizon_years = 3;

% Per-yuan return factors for each option over its duration
% Option 1: after 1 year returns 0.7 per 1 invested
% Option 2: after 2 years returns 2.0 per 1 invested (must be 2-year multiples)
array[OPTIONS] of float: return_factor = [0.7, 2.0];

% Investment duration in years for each option
array[OPTIONS] of int: duration_years = [1, 2];


% Variables
% Amount invested at the start (time 0) in option 1 (1-year investment)
var 0.0..float(initial_capital): invest_opt1_t0;

% Amount invested at the start (time 0) in option 2 (2-year investment)
var 0.0..float(initial_capital): invest_opt2_t0;

% Amount re-invested at the start of year 2 (i.e., after year 1 completes) into option 1
% (Option 2 cannot start at year 2 if we want results by end of year 3, since it needs 2 years.)
var 0.0..float(initial_capital): invest_opt1_t1;

% Total money available at end of year 1
var 0.0..float(initial_capital * 3.0): wealth_end_year1;

% Total money available at end of year 3 (objective target)
var 0.0..float(initial_capital * 10.0): wealth_end_year3;


% Constraints

%--------------------------
% Initial budget allocation (time 0)
%--------------------------
constraint
  % Cannot invest more than the initial capital at time 0
  invest_opt1_t0 + invest_opt2_t0 <= float(initial_capital);

%--------------------------
% Wealth evolution to end of year 1
%--------------------------
constraint
  % End of year 1 wealth comes only from option 1 started at time 0
  % (Option 2 has a 2-year duration, so it does not mature by year 1.)
  wealth_end_year1 = return_factor[1] * invest_opt1_t0;

%--------------------------
% Reinvestment decision at start of year 2 (after year 1 completes)
%--------------------------
constraint
  % Reinvesting into option 1 at year 2 cannot exceed wealth available at end of year 1
  invest_opt1_t1 <= wealth_end_year1;

%--------------------------
% Wealth evolution to end of year 3
%--------------------------
constraint
  % End of year 3 wealth consists of:
  % - Option 2 started at time 0 maturing at end of year 2, then held as cash to end of year 3
  % - Option 1 started at year 2 (time 1) maturing at end of year 3
  wealth_end_year3 =
      return_factor[2] * invest_opt2_t0
    + return_factor[1] * invest_opt1_t1;


% Objective
solve maximize wealth_end_year3;