% Investment planning over 3 years (all data embedded)

% ---------- Data ----------
int: initial_capital = 500000;

% Use integer scaling for multipliers to avoid floats
int: SCALE = 10;
int: r1 = 12;  % 1-year product available at start of years 1..3 => 1.20
int: r2 = 15;  % 2-year product available at start of year 1 => 1.50 (matures end of year 2)
int: r3 = 16;  % same-year product available at start of year 2 => 1.60 (matures end of year 2)
int: r4 = 14;  % 1-year product available at start of year 3 => 1.40

int: cap2 = 120000;
int: cap3 = 150000;
int: cap4 = 100000;

% Tight safe upper bounds (prevents huge search/timeouts)
int: MAXC = initial_capital;

% ---------- Decision variables ----------
var 0..MAXC: x11;        % invest in 1-year product at start of Year 1
var 0..MAXC: x12;        % invest in 1-year product at start of Year 2
var 0..MAXC: x13;        % invest in 1-year product at start of Year 3

var 0..cap2: x2;         % invest in 2-year product at start of Year 1
var 0..cap3: x3;         % invest in same-year product at start of Year 2
var 0..cap4: x4;         % invest in special 1-year product at start of Year 3

var 0..MAXC: cash2;      % cash available at start of Year 2
var 0..MAXC*2: cash3;    % cash available at start of Year 3 (can exceed initial)

var 0..SCALE*MAXC*3: wealth_end3_scaled;

% ---------- Constraints ----------
% Year 1 budget (cash1 = initial_capital)
constraint x11 + x2 <= initial_capital;

% Cash at start of Year 2: proceeds from x11 (1-year product)
constraint cash2 * SCALE = r1 * x11;

% Year 2 budget
constraint x12 + x3 <= cash2;

% Cash at start of Year 3: proceeds from x12, x3, and x2 (2-year)
constraint cash3 * SCALE = r1 * x12 + r3 * x3 + r2 * x2;

% Year 3 budget
constraint x13 + x4 <= cash3;

% End of Year 3 wealth: proceeds from x13 (1-year) and x4 (special 1-year)
constraint wealth_end3_scaled = r1 * x13 + r4 * x4;

% ---------- Objective ----------
solve maximize wealth_end3_scaled;