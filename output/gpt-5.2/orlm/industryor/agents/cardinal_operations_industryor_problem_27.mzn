% Parameters
% Initial fund (yuan)
int: initial_fund = 300000;

% Annual return for project (1): 20% each year, reinvestable
float: r1 = 1.20;

% Project (2): invest at start of year 1, recover end of year 2 (2-year horizon)
float: r2_total = 1.50;
int:   limit2 = 150000;

% Project (3): invest at start of year 2, recover end of year 3
float: r3_total = 1.60;
int:   limit3 = 200000;

% Project (4): invest at start of year 3, recover end of year 3 (1-year), 40% profit
float: r4_total = 1.40;
int:   limit4 = 100000;


% Variables
% Amount invested in project (1) at the beginning of each year (years 1..3)
var 0..initial_fund: invest1_y1;  % invest in year 1 into project (1)
var 0..initial_fund: invest1_y2;  % invest in year 2 into project (1)
var 0..initial_fund: invest1_y3;  % invest in year 3 into project (1)

% Amount invested in project (2) at beginning of year 1 (bounded by limit2)
var 0..limit2: invest2_y1;

% Amount invested in project (3) at beginning of year 2 (bounded by limit3)
var 0..limit3: invest3_y2;

% Amount invested in project (4) at beginning of year 3 (bounded by limit4)
var 0..limit4: invest4_y3;

% Cash available at the beginning of each year (before investing)
var 0..(initial_fund * 10): cash_y1;
var 0..(initial_fund * 10): cash_y2;
var 0..(initial_fund * 10): cash_y3;

% Final wealth (principal + interest) at end of year 3
var 0..(initial_fund * 10): final_wealth;


% Constraints
%----------------------------
% Cash flow initialization
%----------------------------
constraint
  % Cash available at the beginning of year 1 equals the initial fund
  cash_y1 = initial_fund;

%----------------------------
% Investment budget constraints (cannot invest more than available cash)
%----------------------------
constraint
  % Year 1: can invest in project (1) and project (2)
  invest1_y1 + invest2_y1 <= cash_y1;

constraint
  % Year 2: cash comes from reinvesting project (1) year-1 returns; project (2) still locked
  invest1_y2 + invest3_y2 <= cash_y2;

constraint
  % Year 3: cash includes year-2 returns of project (1) and maturity of project (2)
  invest1_y3 + invest4_y3 <= cash_y3;

%----------------------------
% Cash evolution constraints (availability at the beginning of each year)
%----------------------------
constraint
  % Beginning of year 2 cash: year-1 investment in project (1) returns after one year
  cash_y2 = r1 * invest1_y1;

constraint
  % Beginning of year 3 cash: year-2 investment in project (1) returns after one year
  % plus project (2) recovers at end of year 2 (available for year 3)
  cash_y3 = r1 * invest1_y2 + r2_total * invest2_y1;

%----------------------------
% Final wealth at end of year 3 (maturities occurring by end of year 3)
%----------------------------
constraint
  final_wealth =
      r1 * invest1_y3          % project (1) invested in year 3 returns by end of year 3
    + r3_total * invest3_y2     % project (3) invested in year 2 returns by end of year 3
    + r4_total * invest4_y3;    % project (4) invested in year 3 returns by end of year 3


% Objective
solve maximize final_wealth;