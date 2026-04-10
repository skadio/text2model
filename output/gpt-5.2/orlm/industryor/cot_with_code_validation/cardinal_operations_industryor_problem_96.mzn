% Mix design / blending with sulfur constraints
% Uses integer decision variables in kg to avoid Float::linear limits in Gecode.

%---------------------- Data ----------------------%
int: n_raw = 4;
set of int: RAW = 1..n_raw;
int: n_prod = 2;
set of int: PROD = 1..n_prod;

% Raw materials: 1=A, 2=B, 3=C, 4=D
array[RAW] of int: sulfur_raw_ppm = [30000, 10000, 20000, 10000]; % 3%,1%,2%,1% as ppm (1e6 basis)
array[RAW] of int: cost_per_ton   = [6000, 16000, 10000, 15000]; % yuan/ton

% Products: 1=Product A, 2=Product B
array[PROD] of int: sulfur_max_ppm = [25000, 15000]; % 2.5%, 1.5% as ppm
array[PROD] of int: demand_ton     = [100, 200];     % tons
array[PROD] of int: price_per_ton  = [9150, 9150];   % yuan/ton

int: supplyD_max_ton = 50;

% Scale: work in kg
int: KG_PER_TON = 1000;

array[PROD] of int: demand_kg = [demand_ton[p] * KG_PER_TON | p in PROD];
int: supplyD_max_kg = supplyD_max_ton * KG_PER_TON;

%------------------- Variables -------------------%
array[RAW, PROD] of var 0..sum(demand_kg): x_kg;  % kg of raw r used in product p
array[PROD] of var 0..sum(demand_kg): y_kg;       % kg of product p produced

var int: profit_yuan;

%------------------ Constraints ------------------%
% Mass balance
constraint forall(p in PROD)(
  y_kg[p] = sum(r in RAW)(x_kg[r,p])
);

% Demand upper bounds
constraint forall(p in PROD)(
  y_kg[p] <= demand_kg[p]
);

% Limited supply of raw material D (r=4)
constraint sum(p in PROD)(x_kg[4,p]) <= supplyD_max_kg;

% Sulfur constraints (weighted average):
% sum(sulfur_ppm[r] * x_kg[r,p]) <= sulfur_max_ppm[p] * y_kg[p]
constraint forall(p in PROD)(
  sum(r in RAW)(sulfur_raw_ppm[r] * x_kg[r,p]) <= sulfur_max_ppm[p] * y_kg[p]
);

% Profit (yuan): revenue - cost
% Convert kg to tons by dividing by 1000; keep integer by dividing at the end.
% Revenue and cost are computed in "yuan*kg/ton", then divided by 1000.
constraint
  profit_yuan =
    ( sum(p in PROD)(price_per_ton[p] * y_kg[p])
    - sum(r in RAW, p in PROD)(cost_per_ton[r] * x_kg[r,p])
    ) div KG_PER_TON;

%------------------- Objective -------------------%
solve maximize profit_yuan;

%-------------------- Output ---------------------%
output [
  "profit_yuan=", show(profit_yuan), "\n",
  "y_ton=", show([y_kg[p] / KG_PER_TON | p in PROD]), "\n",
  "x_ton=\n",
  concat([ concat([ show(x_kg[r,p] / KG_PER_TON) ++ (if p==n_prod then "\n" else " " endif)
                   | p in PROD ])
           | r in RAW ])
];