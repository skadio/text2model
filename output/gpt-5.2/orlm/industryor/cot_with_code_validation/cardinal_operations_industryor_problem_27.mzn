% Investment planning over 3 years (maximize wealth at end of year 3)
% Use linear constraints with integer (yuan) variables to avoid float/solver slowdowns.

int: initial_fund = 300000;

% Return factors represented as rational multipliers on integers:
% 1.20 = 6/5, 1.50 = 3/2, 1.60 = 8/5, 1.40 = 7/5

int: cap2 = 150000;  % project 2 cap (start year 1, paid end year 2)
int: cap3 = 200000;  % project 3 cap (start year 2, paid end year 3)
int: cap4 = 100000;  % project 4 cap (start year 3, paid end year 3)

% Decision variables (amounts invested, in yuan)
var 0..initial_fund: x1_1; % project 1 at start of year 1
var 0..initial_fund: x1_2; % project 1 at start of year 2
var 0..initial_fund: x1_3; % project 1 at start of year 3

var 0..cap2: x2;           % project 2 at start of year 1
var 0..cap3: x3;           % project 3 at start of year 2
var 0..cap4: x4;           % project 4 at start of year 3

% Wealth variables at start of each year and final wealth (all in yuan)
var 0..1000000000: W1;
var 0..1000000000: W2;
var 0..1000000000: W3;
var 0..1000000000: W4;

constraint W1 = initial_fund;

% Start of year 1 allocation
constraint x1_1 + x2 <= W1;
% Wealth at start of year 2: leftover + 1-year return on x1_1 (1.2*x1_1)
constraint 5 * W2 = 6 * x1_1 + 5 * (W1 - x1_1 - x2);

% Start of year 2 allocation
constraint x1_2 + x3 <= W2;
% Wealth at start of year 3: leftover + 1-year return on x1_2 + return on x2 (1.5*x2)
constraint 10 * W3 = 12 * x1_2 + 15 * x2 + 10 * (W2 - x1_2 - x3);

% Start of year 3 allocation
constraint x1_3 + x4 <= W3;
% Final wealth at end of year 3:
% leftover + 1-year return on x1_3 + return on x3 (1.6*x3) + return on x4 (1.4*x4)
constraint 10 * W4 = 12 * x1_3 + 16 * x3 + 14 * x4 + 10 * (W3 - x1_3 - x4);

solve maximize W4;

output [
  "x1_1=", show(x1_1), "\n",
  "x2=", show(x2), "\n",
  "W2=", show(W2), "\n",
  "x1_2=", show(x1_2), "\n",
  "x3=", show(x3), "\n",
  "W3=", show(W3), "\n",
  "x1_3=", show(x1_3), "\n",
  "x4=", show(x4), "\n",
  "W4=", show(W4), "\n"
];