% Timber purchase/storage/sales planning (linear model)

% Parameters
int: Q = 4;
set of int: QUARTERS = 1..Q;

int: CAP = 200000; % m^3
int: a = 70;       % yuan/m^3
int: b = 100;      % yuan/m^3 per quarter of storage time

array[QUARTERS] of int: buy_price  = [410, 430, 460, 450]; % (10,000 yuan) per (10,000 m^3)
array[QUARTERS] of int: sell_price = [425, 440, 465, 455]; % (10,000 yuan) per (10,000 m^3)
array[QUARTERS] of int: max_sales  = [100, 140, 200, 160]; % (10,000 m^3)

% Capacity in variable units of (10,000 m^3)
int: CAPU = CAP div 10000; % 20

% Storage cost per (10,000 m^3) held for u quarters, in units of (10,000 yuan)
array[0..Q] of int: hold_cost = array1d(0..Q, [0] ++ [a + b*u | u in 1..Q]);

% Variables (units: 10,000 m^3)
array[QUARTERS] of var 0..CAPU: buy;   % purchased at start of quarter
array[QUARTERS] of var 0..CAPU: sell;  % sold within quarter
array[0..Q] of var 0..CAPU: inv;       % end-of-quarter inventory (inv[0] initial)

% Constraints
constraint inv[0] = 0;

constraint forall(t in QUARTERS) (
  inv[t] = inv[t-1] + buy[t] - sell[t]
);

constraint forall(t in QUARTERS) (
  sell[t] <= max_sales[t]
);

constraint forall(t in 0..Q) (
  inv[t] <= CAPU
);

% All inventory sold by end of autumn
constraint inv[Q] = 0;

% Objective: profit in (10,000 yuan)
% Storage cost charged per quarter on end-of-quarter inventory (u = 1)
var int: profit =
  sum(t in QUARTERS)( sell_price[t] * sell[t] - buy_price[t] * buy[t] )
  - sum(t in QUARTERS)( hold_cost[1] * inv[t] );

solve maximize profit;