% Parameters (with values embedded)
int: R = 3; % raw materials: 1=A, 2=B, 3=C
int: P = 3; % products (candy brands): 1=A, 2=B, 3=C

set of int: RAW = 1..R;
set of int: PROD = 1..P;

array[RAW] of float: raw_cost = [2.00, 1.50, 1.00];      % yuan/kg
array[RAW] of float: raw_limit = [2000.0, 2500.0, 1200.0]; % kg/month

array[PROD] of float: proc_fee = [0.50, 0.40, 0.30];     % yuan/kg
array[PROD] of float: sell_price = [3.40, 2.85, 2.25];   % yuan/kg

% Composition constraints (fractions of raw in each product)
% Lower bounds: A in candy A >= 60%, B in candy A >= 15%
float: lb_A_in_A = 0.60;
float: lb_B_in_A = 0.15;

% Upper bounds: A in candy C <= 20%, B in candy C <= 60%, C in candy C <= 50%
float: ub_A_in_C = 0.20;
float: ub_B_in_C = 0.60;
float: ub_C_in_C = 0.50;

% Variables
% x[p] = kg of product p produced
array[PROD] of var 0.0..10000.0: x;

% y[r,p] = kg of raw material r used in product p
array[RAW, PROD] of var 0.0..10000.0: y;

% Constraints
% Material balance per product: sum of raw inputs equals product output
constraint
  forall(p in PROD) (
    sum(r in RAW)(y[r,p]) = x[p]
  );

% Raw material monthly limits
constraint
  forall(r in RAW) (
    sum(p in PROD)(y[r,p]) <= raw_limit[r]
  );

% Quality/composition constraints for product A (p=1): A>=60%, B>=15%
constraint y[1,1] >= lb_A_in_A * x[1];
constraint y[2,1] >= lb_B_in_A * x[1];

% Quality/composition constraints for product C (p=3): A<=20%, B<=60%, C<=50%
constraint y[1,3] <= ub_A_in_C * x[3];
constraint y[2,3] <= ub_B_in_C * x[3];
constraint y[3,3] <= ub_C_in_C * x[3];

% Objective
% Profit = revenue - processing - raw material costs
var float: profit =
  sum(p in PROD)(sell_price[p] * x[p])
  - sum(p in PROD)(proc_fee[p] * x[p])
  - sum(r in RAW, p in PROD)(raw_cost[r] * y[r,p]);

solve maximize profit;