% Investment planning over 3 years (maximize wealth at end of year 3)
% All amounts in yuan.

include "float.mzn";

float: initial_fund = 300000.0;

% Decision variables: amount invested in each project at allowed times
var float: x1_1; % project (1) at beginning of year 1
var float: x1_2; % project (1) at beginning of year 2
var float: x1_3; % project (1) at beginning of year 3

var float: x2;   % project (2) at beginning of year 1 (limit 150k), returns end of year 2
var float: x3;   % project (3) at beginning of year 2 (limit 200k), returns end of year 3
var float: x4;   % project (4) at beginning of year 3 (limit 100k), returns end of year 3

% Nonnegativity and upper bounds
constraint x1_1 >= 0.0 /\ x1_2 >= 0.0 /\ x1_3 >= 0.0;
constraint x2 >= 0.0 /\ x2 <= 150000.0;
constraint x3 >= 0.0 /\ x3 <= 200000.0;
constraint x4 >= 0.0 /\ x4 <= 100000.0;

% Cash flow variables at the beginning of each year
var float: cash_beg_y1;
var float: cash_beg_y2;
var float: cash_beg_y3;

constraint cash_beg_y1 = initial_fund;

% End of year 1 cash available for beginning of year 2 investments:
% - Project (1) invested in year 1 returns 1.2x at end of year 1
% - Project (2) does not return until end of year 2
constraint cash_beg_y2 =
    cash_beg_y1
  - x1_1 - x2
  + 1.2 * x1_1;

% End of year 2 cash available for beginning of year 3 investments:
% - Project (1) year 2 investment returns 1.2x at end of year 2
% - Project (2) returns 1.5x at end of year 2
% - Project (3) does not return until end of year 3
constraint cash_beg_y3 =
    cash_beg_y2
  - x1_2 - x3
  + 1.2 * x1_2
  + 1.5 * x2;

% Budget constraints at each beginning-of-year decision point
constraint x1_1 + x2 <= cash_beg_y1;
constraint x1_2 + x3 <= cash_beg_y2;
constraint x1_3 + x4 <= cash_beg_y3;

% Objective: wealth at end of year 3 (after all year-3-eligible returns)
% End of year 3:
% - uninvested cash from beginning of year 3 remains
% - Project (1) year 3 investment returns 1.2x at end of year 3
% - Project (3) returns 1.6x at end of year 3
% - Project (4) returns 1.4x at end of year 3
var float: final_wealth;
constraint final_wealth =
    cash_beg_y3
  - x1_3 - x4
  + 1.2 * x1_3
  + 1.6 * x3
  + 1.4 * x4;

solve maximize final_wealth;

output [
  "Optimal plan (yuan):\n",
  "x1_1 (Proj1, Year1) = ", show(x1_1), "\n",
  "x1_2 (Proj1, Year2) = ", show(x1_2), "\n",
  "x1_3 (Proj1, Year3) = ", show(x1_3), "\n",
  "x2   (Proj2, Year1) = ", show(x2), "\n",
  "x3   (Proj3, Year2) = ", show(x3), "\n",
  "x4   (Proj4, Year3) = ", show(x4), "\n\n",
  "Cash begin Y1 = ", show(cash_beg_y1), "\n",
  "Cash begin Y2 = ", show(cash_beg_y2), "\n",
  "Cash begin Y3 = ", show(cash_beg_y3), "\n\n",
  "Final wealth end of Year 3 = ", show(final_wealth), "\n"
];