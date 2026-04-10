% Linear programming model embedded in MiniZinc

% Decision variables (nonnegative reals)
var float: A;          % units of product A produced/sold
var float: B;          % units of product B produced/sold
var float: C_sold;     % units of by-product C sold (<= 5)
var float: C_dispose;  % units of by-product C disposed (>= 0)

% Parameters
float: profit_A = 4.0;
float: profit_B = 10.0;
float: profit_C = 3.0;
float: dispose_cost_C = 2.0;

float: t1_A = 2.0;  float: t2_A = 3.0;
float: t1_B = 3.0;  float: t2_B = 4.0;
float: cap1 = 16.0;
float: cap2 = 24.0;

float: C_sell_cap = 5.0;
float: C_per_B = 2.0;

% Constraints: process time capacities
constraint t1_A * A + t1_B * B <= cap1;
constraint t2_A * A + t2_B * B <= cap2;

% By-product balance and sales limit
constraint C_sold + C_dispose = C_per_B * B;
constraint C_sold <= C_sell_cap;

% Nonnegativity
constraint A >= 0.0;
constraint B >= 0.0;
constraint C_sold >= 0.0;
constraint C_dispose >= 0.0;

% Objective: maximize total profit
var float: total_profit = profit_A * A
                        + profit_B * B
                        + profit_C * C_sold
                        - dispose_cost_C * C_dispose;

solve maximize total_profit;

output [
  "A = ", show(A), "\n",
  "B = ", show(B), "\n",
  "C_sold = ", show(C_sold), "\n",
  "C_dispose = ", show(C_dispose), "\n",
  "total_profit = ", show(total_profit), "\n"
];