% Parameters
% Planning horizon (years)
int: T = 3;

% Initial capital available at the beginning of Year 1
int: initial_capital = 500000;

% Interest factors (multipliers) for each product
float: factor_1y = 1.20;     % 1-year product available each year (Years 1-3)
float: factor_2y = 1.50;     % 2-year product available only at start of Year 1
float: factor_y2 = 1.60;     % same-year product available at start of Year 2 (matures end of Year 2)
float: factor_y3 = 1.40;     % 1-year product available at start of Year 3 (matures end of Year 3)

% Investment caps (yuan); "unlimited" handled by cash availability anyway
int: cap_2y = 120000;         % cap for 2-year product at Year 1
int: cap_y2 = 150000;         % cap for same-year product at Year 2
int: cap_y3 = 100000;         % cap for 1-year capped product at Year 3
int: cap_1y = initial_capital; % safe upper bound for per-year 1-year investment

% Variables
% Cash available at the beginning of each year (decision time)
array[1..T] of var 0..initial_capital: cash_begin;

% End-of-year cash after maturities are received (for flow constraints)
array[1..T] of var 0..(initial_capital * 3): cash_end;

% Investment into the 1-year product at the beginning of each year t
array[1..T] of var 0..cap_1y: invest_1y;

% Investment into the 2-year product at the beginning of Year 1 (matures end of Year 2)
var 0..cap_2y: invest_2y_y1;

% Investment into the same-year product at the beginning of Year 2 (matures end of Year 2)
var 0..cap_y2: invest_y2;

% Investment into the 1-year capped product at the beginning of Year 3 (matures end of Year 3)
var 0..cap_y3: invest_y3;

% Total wealth at the end of Year 3 (objective value)
var 0..(initial_capital * 5): wealth_end_y3;

% Constraints
% ----------------------------
% Initial cash availability
% ----------------------------
constraint cash_begin[1] = initial_capital;

% ----------------------------
% Budget (no borrowing) constraints at each decision time
% ----------------------------
constraint invest_1y[1] + invest_2y_y1 <= cash_begin[1];
constraint invest_1y[2] + invest_y2    <= cash_begin[2];
constraint invest_1y[3] + invest_y3    <= cash_begin[3];

% ----------------------------
% End-of-year cash flow (maturities received)
% ----------------------------
constraint
  cash_end[1] = cash_begin[1] - invest_1y[1] - invest_2y_y1
                + float2int(factor_1y * int2float(invest_1y[1]));

constraint
  cash_end[2] = cash_begin[2] - invest_1y[2] - invest_y2
                + float2int(factor_1y * int2float(invest_1y[2]))
                + float2int(factor_2y * int2float(invest_2y_y1))
                + float2int(factor_y2 * int2float(invest_y2));

constraint
  cash_end[3] = cash_begin[3] - invest_1y[3] - invest_y3
                + float2int(factor_1y * int2float(invest_1y[3]))
                + float2int(factor_y3 * int2float(invest_y3));

% ----------------------------
% Cash carryover between years
% ----------------------------
constraint cash_begin[2] = cash_end[1];
constraint cash_begin[3] = cash_end[2];

% ----------------------------
% Wealth definition at end of planning horizon
% ----------------------------
constraint wealth_end_y3 = cash_end[3];

% Objective
solve maximize wealth_end_y3;