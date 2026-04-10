% Candy blending/production profit maximization
% All data embedded as given in Table 1-7.

int: nRM = 3;     % raw materials: A,B,C
int: nP  = 3;     % products (candy brands): A,B,C

set of int: RM = 1..nRM;   % 1=A, 2=B, 3=C
set of int: P  = 1..nP;    % 1=Brand A, 2=Brand B, 3=Brand C

array[RM] of float: rm_cost = [2.00, 1.50, 1.00];      % Yuan/kg
array[RM] of float: rm_limit = [2000.0, 2500.0, 1200.0]; % kg/month

array[P] of float: proc_fee = [0.50, 0.40, 0.30];      % Yuan/kg
array[P] of float: sell_price = [3.40, 2.85, 2.25];    % Yuan/kg

% Decision variables:
% x[r,p] = kg of raw material r used in product p (per month)
array[RM, P] of var 0.0..max(rm_limit): x;

% y[p] = kg produced of product p
array[P] of var 0.0..sum(rm_limit): y;

% Material balance: product output equals sum of its ingredient inputs
constraint forall(p in P)(
  y[p] = sum(r in RM)(x[r,p])
);

% Monthly raw material availability
constraint forall(r in RM)(
  sum(p in P)(x[r,p]) <= rm_limit[r]
);

% Composition constraints from the table:
% Brand A: A >= 60%, B >= 15%
constraint x[1,1] >= 0.60 * y[1];
constraint x[2,1] >= 0.15 * y[1];

% Brand C: A <= 20%, B <= 60%, C <= 50%
constraint x[1,3] <= 0.20 * y[3];
constraint x[2,3] <= 0.60 * y[3];
constraint x[3,3] <= 0.50 * y[3];

% Profit = revenue - raw material cost - processing fees
var float: profit =
  sum(p in P)(sell_price[p] * y[p])
  - sum(r in RM, p in P)(rm_cost[r] * x[r,p])
  - sum(p in P)(proc_fee[p] * y[p]);

solve maximize profit;

output [
  "Optimal monthly production (kg):\n",
  " Brand A: ", show(y[1]), "\n",
  " Brand B: ", show(y[2]), "\n",
  " Brand C: ", show(y[3]), "\n\n",
  "Raw material usage (kg):\n",
  " RM A used: ", show(sum(p in P)(x[1,p])), " / ", show(rm_limit[1]), "\n",
  " RM B used: ", show(sum(p in P)(x[2,p])), " / ", show(rm_limit[2]), "\n",
  " RM C used: ", show(sum(p in P)(x[3,p])), " / ", show(rm_limit[3]), "\n\n",
  "Profit (Yuan): ", show(profit), "\n",
  "\nIngredient breakdown x[r,p] (kg):\n",
  " Product A: A=", show(x[1,1]), " B=", show(x[2,1]), " C=", show(x[3,1]), "\n",
  " Product B: A=", show(x[1,2]), " B=", show(x[2,2]), " C=", show(x[3,2]), "\n",
  " Product C: A=", show(x[1,3]), " B=", show(x[2,3]), " C=", show(x[3,3]), "\n"
];