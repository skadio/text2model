% Parameters (with values embedded)
int: W0 = 500000;

float: r1 = 1.20;          % 1-year product (Years 1-3), end-of-year multiplier
float: r2 = 1.50;          % 2-year product (start Y1 -> end Y2)
int: cap2 = 120000;

float: r3 = 1.60;          % same-year product (start Y2 -> end Y2)
int: cap3 = 150000;

float: r4 = 1.40;          % 1-year product (start Y3 -> end Y3)
int: cap4 = 100000;

% Variables
var 0..W0: x11;                 % invest in 1-year product at start of Year 1
var 0..cap2: x12;               % invest in 2-year product at start of Year 1

var 0..W0: x21;                 % invest in 1-year product at start of Year 2
var 0..cap3: x23;               % invest in same-year product at start of Year 2

var 0..W0: x31;                 % invest in 1-year product at start of Year 3
var 0..cap4: x34;               % invest in 1-year capped product at start of Year 3

var 0..10000000: cash2;         % cash available at beginning of Year 2
var 0..10000000: cash3;         % cash available at beginning of Year 3
var 0..10000000: wealth3;       % total wealth at end of Year 3

% Constraints
constraint cash2 = r1 * x11;                          % end Y1 proceeds become start Y2 cash
constraint cash3 = r1 * x21 + r2 * x12 + r3 * x23;    % end Y2 proceeds become start Y3 cash
constraint wealth3 = r1 * x31 + r4 * x34;             % end Y3 wealth (all mature at end Y3)

% Cash availability (no borrowing; may hold cash by not investing all)
constraint x11 + x12 <= W0;
constraint x21 + x23 <= cash2;
constraint x31 + x34 <= cash3;

% Objective
solve maximize wealth3;