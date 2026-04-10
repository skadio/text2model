% Candy factory blending / production planning (LP)
% Data embedded from the statement.

set of int: RM = 1..3;     % raw materials: 1=A, 2=B, 3=C
set of int: PROD = 1..3;   % products/candies: 1=A, 2=B, 3=C

array[RM] of string: rm_name = ["A","B","C"];
array[PROD] of string: prod_name = ["A","B","C"];

array[RM] of float: rm_cost  = [2.00, 1.50, 1.00];          % Yuan/kg
array[RM] of float: rm_limit = [2000.0, 2500.0, 1200.0];    % kg/month

array[PROD] of float: proc_fee   = [0.50, 0.40, 0.30];      % Yuan/kg product
array[PROD] of float: sell_price = [3.40, 2.85, 2.25];      % Yuan/kg product

% Composition constraints (fractions)
float: minA_in_A = 0.60;
float: minB_in_A = 0.15;

float: maxA_in_C = 0.20;
float: maxB_in_C = 0.60;
float: maxC_in_C = 0.50;

float: total_rm_limit = sum(r in RM)(rm_limit[r]);
float: max_rm_limit = max(r in RM)(rm_limit[r]);

% Decision variables
array[PROD] of var 0.0..total_rm_limit: x;                   % kg produced of each product
array[RM,PROD] of var 0.0..max_rm_limit: y;                  % kg of raw material r used in product p
var float: profit;

% Constraints
constraint forall(p in PROD)(
  sum(r in RM)(y[r,p]) = x[p]
);

constraint forall(r in RM)(
  sum(p in PROD)(y[r,p]) <= rm_limit[r]
);

% Product A (p=1): A>=60%, B>=15%
constraint y[1,1] >= minA_in_A * x[1];
constraint y[2,1] >= minB_in_A * x[1];

% Product C (p=3): A<=20%, B<=60%, C<=50%
constraint y[1,3] <= maxA_in_C * x[3];
constraint y[2,3] <= maxB_in_C * x[3];
constraint y[3,3] <= maxC_in_C * x[3];

% Profit = revenue - processing - raw material costs
constraint
  profit =
    sum(p in PROD)( sell_price[p] * x[p] - proc_fee[p] * x[p] )
    - sum(r in RM, p in PROD)( rm_cost[r] * y[r,p] );

% Use LP solver backend to avoid timeouts on float optimization with CP
solve :: lp maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Production (kg):\n"
] ++ [
  prod_name[p] ++ ": " ++ show(x[p]) ++ "\n"
  | p in PROD
];