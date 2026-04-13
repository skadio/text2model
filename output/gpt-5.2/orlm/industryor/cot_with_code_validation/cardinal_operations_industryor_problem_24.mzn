% Investment planning over 3 years
% Data (embedded)
int: B = 100000;      % initial budget (yuan)
float: r1 = 0.7;      % option 1 return after 1 year (profit per yuan invested)
float: r2 = 2.0;      % option 2 return after 2 years (profit per yuan invested)

% Decision variables (yuan invested at the start of each year)
var 0..B: x11;  % option 1 at start of year 1
var 0..B: x12;  % option 1 at start of year 2
var 0..B: x13;  % option 1 at start of year 3
var 0..B: x21;  % option 2 at start of year 1 (matures end of year 2)
var 0..B: x22;  % option 2 at start of year 2 (matures end of year 3)

% Wealth variables
var float: W1;  % wealth at start of year 1
var float: W2;  % wealth at start of year 2
var float: W3;  % wealth at start of year 3
var float: W4;  % wealth at end of year 3 (objective)

% Constraints (cashflow balance)
constraint W1 = float(B);

constraint x11 + x21 <= W1;
constraint W2 = (W1 - (x11 + x21)) + (1.0 + r1) * x11;

constraint x12 + x22 <= W2;
constraint W3 = (W2 - (x12 + x22)) + (1.0 + r1) * x12 + (1.0 + r2) * x21;

constraint x13 <= W3;
constraint W4 = (W3 - x13) + (1.0 + r1) * x13 + (1.0 + r2) * x22;

% Objective: maximize wealth at end of year 3
solve maximize W4;

% Output
output [
  "x11=", show(x11), "  x21=", show(x21), "\n",
  "x12=", show(x12), "  x22=", show(x22), "\n",
  "x13=", show(x13), "\n",
  "W4=", show(W4), "\n"
];