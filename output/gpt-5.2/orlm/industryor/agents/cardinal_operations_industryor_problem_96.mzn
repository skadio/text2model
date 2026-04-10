% Parameters
% Sets / indices
set of int: RAW = 1..4;         % 1=Raw A, 2=Raw B, 3=Raw C, 4=Raw D
set of int: PROD = 1..2;        % 1=Product A, 2=Product B

% Sulfur content (fraction)
array[RAW] of float: sulfur_raw = [0.03, 0.01, 0.02, 0.01];

% Purchase prices (thousand yuan per ton)
array[RAW] of float: buy_price = [6.0, 16.0, 10.0, 15.0];

% Max sulfur allowed in products (fraction)
array[PROD] of float: sulfur_max_prod = [0.025, 0.015];

% Selling prices (thousand yuan per ton)
array[PROD] of float: sell_price = [9.15, 9.15];

% Supply limits (tons); BIG represents "unlimited"
float: BIG = 1.0e6;
array[RAW] of float: supply_max_raw = [BIG, BIG, BIG, 50.0];

% Demands (tons)
array[PROD] of float: demand_prod = [100.0, 200.0];


% Variables
% Amount of raw i used in product p (tons)
array[RAW, PROD] of var float: use_raw_in_prod;

% Total production of product p (tons)
array[PROD] of var float: prod_qty;

% Total usage of raw i across all products (tons)
array[RAW] of var float: total_use_raw;

% Profit (thousand yuan)
var float: profit;


% Constraints

%----------------------------
% Nonnegativity constraints
%----------------------------
constraint forall(i in RAW, p in PROD) (
  use_raw_in_prod[i,p] >= 0.0
);

constraint forall(p in PROD) (
  prod_qty[p] >= 0.0
);

constraint forall(i in RAW) (
  total_use_raw[i] >= 0.0
);

%---------------------------------------------
% Material balance: totals and product yields
%---------------------------------------------
constraint forall(i in RAW) (
  total_use_raw[i] = sum(p in PROD)(use_raw_in_prod[i,p])
);

constraint forall(p in PROD) (
  prod_qty[p] = sum(i in RAW)(use_raw_in_prod[i,p])
);

%----------------------------
% Supply limit constraints
%----------------------------
constraint forall(i in RAW) (
  total_use_raw[i] <= supply_max_raw[i]
);

%-----------------------------------------
% Demand constraints (meet market demand)
%-----------------------------------------
constraint forall(p in PROD) (
  prod_qty[p] = demand_prod[p]
);

%-----------------------------------------
% Sulfur content constraints for products
% Weighted-average sulfur <= max allowed
%-----------------------------------------
constraint forall(p in PROD) (
  sum(i in RAW)(sulfur_raw[i] * use_raw_in_prod[i,p])
  <= sulfur_max_prod[p] * prod_qty[p]
);

%-------------------------------------------------------------
% Process constraint: A, B, D must be pre-mixed before mixing
% with C. Enforce that A,B,D are used in identical proportions
% across all products (i.e., a single A:B:D premix split to A/B).
% Implemented via cross-multiplication to avoid division.
%-------------------------------------------------------------
constraint forall(p in PROD) (
  use_raw_in_prod[1,p] * total_use_raw[2] = use_raw_in_prod[2,p] * total_use_raw[1]
);

constraint forall(p in PROD) (
  use_raw_in_prod[1,p] * total_use_raw[4] = use_raw_in_prod[4,p] * total_use_raw[1]
);

%----------------------------
% Profit definition constraint
%----------------------------
constraint
  profit =
    sum(p in PROD)(sell_price[p] * prod_qty[p])
  - sum(i in RAW)(buy_price[i] * total_use_raw[i]);


% Objective
solve maximize profit;