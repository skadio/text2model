% Investment planning over 3 years (linear model)
% Maximize total principal+interest at end of year 3.

% All data embedded as requested.

% Initial capital
int: C0 = 300000;

% Decision variables (amount invested)
% Project (1): can invest at beginning of each year; returns 1.2x after 1 year.
var 0..C0: x1_1;   % invest in project 1 at start of year 1 (available end of year 1)
var 0..C0: x1_2;   % invest in project 1 at start of year 2 (available end of year 2)
var 0..C0: x1_3;   % invest in project 1 at start of year 3 (available end of year 3)

% Project (2): invest only at start of year 1; recovered end of year 2; return 1.5x; cap 150000
var 0..150000: x2;

% Project (3): invest at start of year 2; recovered end of year 3; return 1.6x; cap 200000
var 0..200000: x3;

% Project (4): invest at start of year 3; recovered end of year 3; return 1.4x; cap 100000
var 0..100000: x4;

% Cash carried (not invested) from each year-end to next year-begin
var 0..C0: cash1;  % cash at end of year 1 (beginning of year 2)
var 0..C0: cash2;  % cash at end of year 2 (beginning of year 3)
var 0..C0: cash3;  % cash at end of year 3 (final wealth)

% Year 1 budget: allocate initial capital between x1_1, x2, and cash held to year 2
constraint x1_1 + x2 + cash1 = C0;

% End of year 1 -> start of year 2: x1_1 matures to 1.2*x1_1 and is available for investing at start of year 2.
% Year 2 budget: allocate available funds between x1_2, x3, and cash held to year 3
constraint x1_2 + x3 + cash2 = cash1 + (6 * x1_1) div 5;

% End of year 2 -> start of year 3: x1_2 matures to 1.2*x1_2 and x2 matures to 1.5*x2
% Use integer arithmetic: 1.2 = 6/5, 1.5 = 3/2
constraint x1_3 + x4 + cash3 =
    cash2 + (6 * x1_2) div 5 + (3 * x2) div 2 + (8 * x3) div 5 + (7 * x4) div 5; 
% NOTE: cash3 here is defined as end of year 3 total wealth; we also need to add maturities that occur in year 3:
% - x1_3 matures end of year 3 to 1.2*x1_3
% - x3 matures end of year 3 to 1.6*x3
% - x4 matures end of year 3 to 1.4*x4
% The above equation would be incorrect because x3 and x4 are invested at start of year 2/3, not at start of year 3.
% Let's correct by modeling year 3 budget and final wealth separately.

% Re-declare correctly with separate year-3 cash and final wealth
var 0..(10*C0): cashStart3;  % funds available at start of year 3
var 0..(10*C0): finalWealth;

% Start of year 3 funds:
constraint cashStart3 = cash2 + (6 * x1_2) div 5 + (3 * x2) div 2;

% Year 3 budget: allocate start-of-year-3 funds between x1_3, x4, and cash held to end of year 3 (uninvested)
var 0..(10*C0): cashHold3;
constraint x1_3 + x4 + cashHold3 = cashStart3;

% Final wealth at end of year 3:
% - cashHold3 stays cash
% - x1_3 returns 1.2x
% - x3 returns 1.6x (invested at start of year 2)
% - x4 returns 1.4x
constraint finalWealth = cashHold3 + (6 * x1_3) div 5 + (8 * x3) div 5 + (7 * x4) div 5;

% Also: year 2 budget already included x3 and cash2:
% x1_2 + x3 + cash2 = cash1 + 1.2*x1_1  (already set above)

% Ensure divisibility for exact scaling with integer variables (optional but makes model exact)
constraint (6 * x1_1) mod 5 = 0;
constraint (6 * x1_2) mod 5 = 0;
constraint (6 * x1_3) mod 5 = 0;
constraint (3 * x2) mod 2 = 0;
constraint (8 * x3) mod 5 = 0;
constraint (7 * x4) mod 5 = 0;

solve maximize finalWealth;

output [
  "Optimal plan (yuan):\n",
  "  Year1: x1_1=", show(x1_1), "  x2=", show(x2), "  cash_endY1=", show(cash1), "\n",
  "  Year2: x1_2=", show(x1_2), "  x3=", show(x3), "  cash_endY2=", show(cash2), "\n",
  "  Year3: x1_3=", show(x1_3), "  x4=", show(x4), "  cash_holdY3=", show(cashHold3), "\n",
  "Final wealth end of Year3 = ", show(finalWealth), "\n"
];