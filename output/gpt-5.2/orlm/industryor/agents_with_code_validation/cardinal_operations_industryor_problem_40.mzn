% Investment planning over 3 years (maximize wealth at end of Year 3)
% Fix: the original model timed out because it used float coefficients with large integer domains,
% which can lead to poor propagation / search. This version scales all money to "10,000 yuan units"
% and uses integer multipliers throughout (exact arithmetic).

% ----------------------------
% Scaling
% 1 unit = 10,000 yuan
% initial capital = 500,000 yuan = 50 units
% caps: 120,000 -> 12, 150,000 -> 15, 100,000 -> 10
% multipliers: 1.20=120/100, 1.50=150/100, 1.60=160/100, 1.40=140/100
% To avoid fractions, we keep wealth in "cents of units" with scale 100.
% ----------------------------

int: initial_capital = 50;  % units of 10,000 yuan

int: cap2 = 12;
int: cap3 = 15;
int: cap4 = 10;

% Integer multipliers (x/100)
int: r1 = 120;
int: r2 = 150;
int: r3 = 160;
int: r4 = 140;

% Decision variables (in 10,000 yuan units)
var 0..initial_capital: invest1_y1;
var 0..cap2:           invest2_y1;

var 0..initial_capital: invest1_y2;
var 0..cap3:            invest3_y2;

var 0..initial_capital: invest1_y3;
var 0..cap4:            invest4_y3;

% Wealth tracked in "100ths of units" (i.e., 0.01 * 10,000 = 100 yuan)
var 0..10000000: cash_y2_100;   % available cash at start of Year 2 (scaled by 100)
var 0..10000000: cash_y3_100;   % available cash at start of Year 3 (scaled by 100)
var 0..10000000: wealth_y3_100; % objective: end of Year 3 wealth (scaled by 100)

% ----------------------------
% Constraints
% ----------------------------

% Start of Year 1 budget (can leave cash uninvested)
constraint invest1_y1 + invest2_y1 <= initial_capital;

% Cash at start of Year 2:
% = uninvested from Year 1 + maturity of invest1_y1
% Uninvested = initial_capital - invest1_y1 - invest2_y1 (carried with no interest)
constraint
  cash_y2_100 =
    100 * (initial_capital - invest1_y1 - invest2_y1) + r1 * invest1_y1;

% Year 2 investments must not exceed available cash
constraint 100 * (invest1_y2 + invest3_y2) <= cash_y2_100;

% Cash at start of Year 3:
% = uninvested from Year 2 + maturities at end of Year 2 (invest2_y1, invest1_y2, invest3_y2)
constraint
  cash_y3_100 =
    (cash_y2_100 - 100 * (invest1_y2 + invest3_y2))
    + r2 * invest2_y1 + r1 * invest1_y2 + r3 * invest3_y2;

% Year 3 investments must not exceed available cash
constraint 100 * (invest1_y3 + invest4_y3) <= cash_y3_100;

% End of Year 3 wealth:
% = uninvested from Year 3 + maturities at end of Year 3
constraint
  wealth_y3_100 =
    (cash_y3_100 - 100 * (invest1_y3 + invest4_y3))
    + r1 * invest1_y3 + r4 * invest4_y3;

solve maximize wealth_y3_100;

output [
  "Investments in 10,000-yuan units:\n",
  "  Y1: invest1=", show(invest1_y1), ", invest2=", show(invest2_y1), "\n",
  "  Y2: invest1=", show(invest1_y2), ", invest3=", show(invest3_y2), "\n",
  "  Y3: invest1=", show(invest1_y3), ", invest4=", show(invest4_y3), "\n",
  "End wealth (scaled by 100) = ", show(wealth_y3_100), "\n",
  "End wealth (yuan) = ", show(wealth_y3_100 * 100), "\n"
];