% Investment planning over 3 years (no borrowing), maximize wealth at end of Year 3
% All data embedded.

int: InitialCapital = 500000;

% Decision variables (amount invested in each project at its availability time)
var 0..InitialCapital: x1_y1; % Project (1) invested at beginning of Year 1, matures end of Year 1
var 0..InitialCapital: x1_y2; % Project (1) invested at beginning of Year 2, matures end of Year 2
var 0..InitialCapital: x1_y3; % Project (1) invested at beginning of Year 3, matures end of Year 3

var 0..120000: x2;            % Project (2) invested at beginning of Year 1, matures end of Year 2
var 0..150000: x3;            % Project (3) invested at beginning of Year 2, matures end of Year 2
var 0..100000: x4;            % Project (4) invested at beginning of Year 3, matures end of Year 3

% Cash available at the beginnings of Years 2 and 3 (derived)
var float: cash_y2;
var float: cash_y3;

% Final wealth at end of Year 3
var float: wealth_end_y3;

constraint
  % Year 1 allocation (start of Year 1)
  x1_y1 + x2 <= InitialCapital;

constraint
  % Cash at start of Year 2: proceeds from x1_y1
  cash_y2 = 1.20 * x1_y1;

constraint
  % Year 2 allocation (start of Year 2)
  x1_y2 + x3 <= cash_y2;

constraint
  % Cash at start of Year 3: proceeds from x1_y2, x2, x3 (all mature end of Year 2)
  cash_y3 = 1.20 * x1_y2 + 1.50 * x2 + 1.60 * x3;

constraint
  % Year 3 allocation (start of Year 3)
  x1_y3 + x4 <= cash_y3;

constraint
  % End of Year 3 wealth: proceeds from Year 3 investments
  wealth_end_y3 = 1.20 * x1_y3 + 1.40 * x4;

solve maximize wealth_end_y3;

output [
  "x1_y1 (Proj1 @Y1) = ", show(x1_y1), "\n",
  "x2    (Proj2 @Y1) = ", show(x2), "\n",
  "cash_y2 (start Y2)= ", show(cash_y2), "\n",
  "x1_y2 (Proj1 @Y2) = ", show(x1_y2), "\n",
  "x3    (Proj3 @Y2) = ", show(x3), "\n",
  "cash_y3 (start Y3)= ", show(cash_y3), "\n",
  "x1_y3 (Proj1 @Y3) = ", show(x1_y3), "\n",
  "x4    (Proj4 @Y3) = ", show(x4), "\n",
  "Wealth end of Y3  = ", show(wealth_end_y3), "\n"
];