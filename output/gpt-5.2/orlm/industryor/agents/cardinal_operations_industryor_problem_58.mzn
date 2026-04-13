% Parameters
% Sets / indices
int: n_materials = 3;
set of int: MATERIALS = 1..n_materials; % 1=A, 2=B, 3=C

int: n_products = 3;
set of int: PRODUCTS = 1..n_products;   % 1=A, 2=B, 3=C

% Raw material costs (Yuan/kg): A=2.00, B=1.50, C=1.00
array[MATERIALS] of float: raw_cost = [2.00, 1.50, 1.00];

% Monthly raw material limits (kg): A=2000, B=2500, C=1200
array[MATERIALS] of int: raw_limit = [2000, 2500, 1200];

% Processing fee per kg of product (Yuan/kg): product A=0.50, B=0.40, C=0.30
array[PRODUCTS] of float: proc_fee = [0.50, 0.40, 0.30];

% Selling price per kg of product (Yuan/kg): product A=3.40, B=2.85, C=2.25
array[PRODUCTS] of float: sell_price = [3.40, 2.85, 2.25];

% Composition constraints expressed as bounds on fraction (0..1).
% min_frac[m,p] = minimum fraction of material m in product p (0 if none)
array[MATERIALS, PRODUCTS] of float: min_frac =
  [| 0.60, 0.00, 0.00   % material A in products A,B,C
   | 0.15, 0.00, 0.00   % material B in products A,B,C
   | 0.00, 0.00, 0.00 | % material C in products A,B,C
  ];

% max_frac[m,p] = maximum fraction of material m in product p (1 if none)
array[MATERIALS, PRODUCTS] of float: max_frac =
  [| 1.00, 1.00, 0.20   % material A in products A,B,C (product C has A <= 20%)
   | 1.00, 1.00, 0.60   % material B in products A,B,C (product C has B <= 60%)
   | 1.00, 1.00, 0.50 | % material C in products A,B,C (product C has C <= 50%)
  ];


% Variables
% Production quantity for each candy brand (kg/month)
array[PRODUCTS] of var 0..max(raw_limit): x_prod;

% Amount of raw material used in each product (kg/month)
array[MATERIALS, PRODUCTS] of var 0..max(raw_limit): use;

% Total profit (Yuan/month)
var float: profit;


% Constraints
% --- Material balance: total material used equals produced quantity for each product ---
constraint
  forall(p in PRODUCTS) (
    sum(m in MATERIALS)(use[m,p]) = x_prod[p]
  );

% --- Monthly availability limits for each raw material ---
constraint
  forall(m in MATERIALS) (
    sum(p in PRODUCTS)(use[m,p]) <= raw_limit[m]
  );

% --- Composition constraints: minimum fraction bounds ---
constraint
  forall(m in MATERIALS, p in PRODUCTS where min_frac[m,p] > 0.0) (
    use[m,p] >= min_frac[m,p] * x_prod[p]
  );

% --- Composition constraints: maximum fraction bounds ---
constraint
  forall(m in MATERIALS, p in PRODUCTS where max_frac[m,p] < 1.0) (
    use[m,p] <= max_frac[m,p] * x_prod[p]
  );

% --- Profit definition (revenue - processing cost - raw material cost) ---
constraint
  profit =
    sum(p in PRODUCTS)(
      (sell_price[p] - proc_fee[p]) * x_prod[p]
    )
    - sum(m in MATERIALS, p in PRODUCTS)(
      raw_cost[m] * use[m,p]
    );


% Objective
solve maximize profit;