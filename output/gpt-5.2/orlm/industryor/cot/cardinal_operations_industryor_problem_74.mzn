% Parameters (with values embedded)
int: time1_A = 2;
int: time2_A = 3;
int: time1_B = 3;
int: time2_B = 4;

int: avail_time1 = 16;
int: avail_time2 = 24;

int: C_per_B = 2;
int: C_sell_cap = 5;

int: profit_A = 4;
int: profit_B = 10;
int: profit_C_sold = 3;
int: cost_C_dispose = 2;

% Variables
var 0..avail_time1 div time1_A: xA; % units of product A
var 0..avail_time1 div time1_B: xB; % units of product B

% By-product C amounts (derived from xB, but kept as variables for clarity)
var 0..(C_per_B * (avail_time1 div time1_B)): c_total;
var 0..C_sell_cap: c_sold;
var 0..(C_per_B * (avail_time1 div time1_B)): c_disposed;

% Constraints
constraint time1_A * xA + time1_B * xB <= avail_time1;
constraint time2_A * xA + time2_B * xB <= avail_time2;

constraint c_total = C_per_B * xB;
constraint c_sold + c_disposed = c_total;
constraint c_sold <= C_sell_cap;

% Objective
var int: total_profit =
    profit_A * xA
  + profit_B * xB
  + profit_C_sold * c_sold
  - cost_C_dispose * c_disposed;

solve maximize total_profit;