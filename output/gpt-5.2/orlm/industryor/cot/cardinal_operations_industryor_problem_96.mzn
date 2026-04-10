% Parameters (with values embedded)
int: nRaw = 4;
set of int: RAW = 1..nRaw;
int: nProd = 2;
set of int: PROD = 1..nProd;

% Raw materials: 1=A, 2=B, 3=C, 4=D
array[RAW] of float: sulfur = [0.03, 0.01, 0.02, 0.01];
array[RAW] of float: buyPrice = [6.0, 16.0, 10.0, 15.0]; % thousand yuan/ton

% Products: 1=Product A, 2=Product B
array[PROD] of float: sulfurMax = [0.025, 0.015];
array[PROD] of float: demandMax = [100.0, 200.0]; % tons
array[PROD] of float: sellPrice = [9.15, 9.15]; % thousand yuan/ton

float: D_supply_max = 50.0; % tons

% Variables
% x[i,j] = tons of raw material i used in product j
array[RAW, PROD] of var float: x;

% y[j] = tons of product j produced/sold
array[PROD] of var float: y;

% Constraints
constraint
  forall(i in RAW, j in PROD) ( x[i,j] >= 0.0 );

constraint
  forall(j in PROD) ( y[j] >= 0.0 );

% Mass balance: total inputs equal output for each product
constraint
  forall(j in PROD) (
    y[j] = sum(i in RAW)(x[i,j])
  );

% Demand limits
constraint
  forall(j in PROD) (
    y[j] <= demandMax[j]
  );

% Sulfur content constraints per product
constraint
  forall(j in PROD) (
    sum(i in RAW)(sulfur[i] * x[i,j]) <= sulfurMax[j] * y[j]
  );

% Limited supply of raw material D (i=4)
constraint
  sum(j in PROD)(x[4,j]) <= D_supply_max;

% Objective
var float: profit =
  sum(j in PROD)(sellPrice[j] * y[j]) - sum(i in RAW, j in PROD)(buyPrice[i] * x[i,j]);

solve maximize profit;