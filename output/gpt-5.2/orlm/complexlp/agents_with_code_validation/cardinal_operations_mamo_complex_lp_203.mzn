% Solar Oil blending problem (LP)
% Data embedded as per problem statement.

int: nRaw = 4;
set of int: RAW = 1..nRaw;

int: nProd = 2;  % 1=regular, 2=premium
set of int: PROD = 1..nProd;

array[RAW] of float: raw_octane = [86.0, 88.0, 92.0, 96.0];
array[RAW] of float: raw_avail  = [20000.0, 15000.0, 15000.0, 10000.0];
array[RAW] of float: raw_cost   = [17.0, 18.0, 20.5, 23.0];

array[PROD] of float: min_octane = [89.0, 93.0];
array[PROD] of float: demand_max = [35000.0, 23000.0];
array[PROD] of float: sell_price = [19.5, 22.0];

% Decision variables (continuous to keep it a pure LP and avoid timeouts)
array[RAW, PROD] of var float: blend;        % barrels/day of raw i used in product p
array[PROD] of var float: production;        % total barrels/day produced of product p
var float: profit;

% Nonnegativity and simple upper bounds
constraint forall(i in RAW, p in PROD) (
  0.0 <= blend[i,p] /\ blend[i,p] <= demand_max[p]
);

constraint forall(p in PROD) (
  0.0 <= production[p] /\ production[p] <= demand_max[p]
);

% Volume balance per product
constraint forall(p in PROD) (
  production[p] = sum(i in RAW)(blend[i,p])
);

% Raw availability limits
constraint forall(i in RAW) (
  sum(p in PROD)(blend[i,p]) <= raw_avail[i]
);

% Octane constraints (cross-multiplied weighted average)
constraint forall(p in PROD) (
  sum(i in RAW)(raw_octane[i] * blend[i,p]) >= min_octane[p] * production[p]
);

% Profit = revenue - raw material costs
constraint profit =
  sum(p in PROD)(sell_price[p] * production[p])
  - sum(i in RAW, p in PROD)(raw_cost[i] * blend[i,p]);

solve maximize profit;