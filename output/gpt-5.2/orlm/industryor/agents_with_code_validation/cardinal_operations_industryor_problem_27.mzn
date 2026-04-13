% Investment planning over 3 years (all data embedded)

% --------------------
% Parameters
% --------------------
int: initial_fund = 300000;

int: T = 3;
set of int: YEARS = 1..T;

% Returns (multipliers)
float: p1_return = 1.20;  % invest at start of year t, recover end of year t
float: p2_return = 1.50;  % invest at start of year 1, recover end of year 2
float: p3_return = 1.60;  % invest at start of year 2, recover end of year 3
float: p4_return = 1.40;  % invest at start of year 3, recover end of year 3

% Caps
int: p2_cap = 150000;
int: p3_cap = 200000;
int: p4_cap = 100000;

% A safe upper bound for cash/wealth (not tight, but sufficient)
int: UB = initial_fund * 10;

% --------------------
% Decision variables
% --------------------
array[YEARS] of var 0..initial_fund: invest_p1;

var 0..p2_cap: invest_p2;
var 0..p3_cap: invest_p3;
var 0..p4_cap: invest_p4;

array[YEARS] of var 0..UB: cash_begin;
array[YEARS] of var 0..UB: cash_end;

var 0..UB: final_wealth;

% --------------------
% Constraints
% --------------------
constraint cash_begin[1] = initial_fund;

% Budget constraints at the beginning of each year
constraint invest_p1[1] + invest_p2 <= cash_begin[1];
constraint invest_p1[2] + invest_p3 <= cash_begin[2];
constraint invest_p1[3] + invest_p4 <= cash_begin[3];

% End of year 1 cash flow
constraint
  cash_end[1] =
    cash_begin[1]
    - invest_p1[1] - invest_p2
    + p1_return * invest_p1[1];

% End of year 2 cash flow
constraint
  cash_end[2] =
    cash_begin[2]
    - invest_p1[2] - invest_p3
    + p1_return * invest_p1[2]
    + p2_return * invest_p2;

% End of year 3 cash flow
constraint
  cash_end[3] =
    cash_begin[3]
    - invest_p1[3] - invest_p4
    + p1_return * invest_p1[3]
    + p3_return * invest_p3
    + p4_return * invest_p4;

% Link years: next year's starting cash equals previous year's ending cash
constraint forall(t in 1..T-1) (
  cash_begin[t+1] = cash_end[t]
);

constraint final_wealth = cash_end[3];

% --------------------
% Objective
% --------------------
solve maximize final_wealth;