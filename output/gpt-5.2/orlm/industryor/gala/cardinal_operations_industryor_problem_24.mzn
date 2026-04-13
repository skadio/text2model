% Investment planning as a (mixed-)linear programming model in MiniZinc
% Data embedded per instructions.

% ----- Data -----
int: B = 100000;              % initial budget (yuan)
float: r1 = 0.7;              % profit per 1 yuan invested in option 1 after 1 year
float: r2 = 2.0;              % profit per 1 yuan invested in option 2 after 2 years
int: H = 3;                   % planning horizon in years

% Option 2 must be invested for 2 years (multiples of 2); within 3-year horizon,
% it can only be started in year 1 (matures end of year 2) or year 2 (matures end of year 3).

% ----- Decision variables -----
% x1[t] = amount invested in option 1 at start of year t (t=1..3), matures after 1 year
array[1..H] of var 0.0..B: x1;

% x2[t] = amount invested in option 2 at start of year t (t=1..2), matures after 2 years
array[1..H-1] of var 0.0..B: x2;

% cash available at the start of each year (before investing that year)
array[1..H] of var 0.0..1.0e18: cash;

% terminal wealth at end of year 3
var 0.0..1.0e18: wealth_end3;

% ----- Constraints (cash flow / budget) -----
constraint cash[1] = B;

% Each year's investments cannot exceed available cash
constraint forall(t in 1..H)(
  x1[t] + (if t <= H-1 then x2[t] else 0.0 endif) <= cash[t]
);

% Cash evolution:
% cash[t+1] = leftover cash after investing in year t
%             + maturity from option 1 invested in year t (principal + profit)
%             + maturity from option 2 invested in year t-1 (principal + profit), for t>=2
constraint forall(t in 1..H-1)(
  cash[t+1]
  =
  (cash[t] - x1[t] - x2[t])          % leftover after investing (for t<=2)
  + x1[t] * (1.0 + r1)              % option 1 matures after 1 year
  + (if t >= 2 then x2[t-1] * (1.0 + r2) else 0.0 endif) % option 2 matures after 2 years
);

% End of year 3 wealth:
% wealth_end3 = cash at start of year 3
%               - investments started in year 3 (only option 1 possible)
%               + maturity from option 1 invested in year 3 (end of year 3)
%               + maturity from option 2 invested in year 2 (end of year 3)
constraint wealth_end3
  =
  (cash[3] - x1[3]) + x1[3] * (1.0 + r1) + x2[2] * (1.0 + r2);

% ----- Objective -----
solve maximize wealth_end3;

% ----- Output -----
output [
  "Optimal plan (yuan):\n",
  "Year 1: x1 = ", show(x1[1]), ", x2 = ", show(x2[1]), "\n",
  "Year 2: x1 = ", show(x1[2]), ", x2 = ", show(x2[2]), "\n",
  "Year 3: x1 = ", show(x1[3]), " (x2 not allowed)\n\n",
  "Cash at start of years: ", show(cash), "\n",
  "Wealth end of year 3 = ", show(wealth_end3), "\n",
  "Earnings (profit) = ", show(wealth_end3 - B), "\n"
];