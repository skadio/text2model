% Mixing problem (linear). Use integer scaling to avoid Gecode float-linear limits.

%%%%%%%%%%%%
% Sets
%%%%%%%%%%%%
set of int: RM = 1..4;   % Raw materials: 1=A, 2=B, 3=C, 4=D
set of int: P  = 1..2;   % Products: 1=ProdA, 2=ProdB

%%%%%%%%%%%%
% Data (embedded)
%%%%%%%%%%%%
% Sulfur in permille (‰): 3% = 30‰, 1% = 10‰, 2% = 20‰
array[RM] of int: sulfur_rm_pm = [30, 10, 20, 10];

% Max sulfur in permille: 2.5% = 25‰, 1.5% = 15‰
array[P] of int: sulfur_max_pm = [25, 15];

% Prices/costs in cents of thousand yuan per ton:
% 6 -> 600, 16 -> 1600, 10 -> 1000, 15 -> 1500, 9.15 -> 915
array[RM] of int: cost_rm_c = [600, 1600, 1000, 1500];
array[P]  of int: price_p_c = [915, 915];

% Demands (tons) - treat as upper bounds
array[P] of int: demand_p = [100, 200];

int: D_supply_max = 50;

%%%%%%%%%%%%
% Variables
%%%%%%%%%%%%
% Use integer tons to keep the model linear and within solver limits
array[RM, P] of var 0..1000: x;  % tons of raw material r used in product p
array[P] of var 0..2000: prod;   % total tons produced of product p
var int: profit_c;               % profit in cents of thousand yuan

%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%
% Mass balance
constraint forall(p in P) (
  prod[p] = sum(r in RM)(x[r,p])
);

% Demand limits
constraint forall(p in P) (
  prod[p] <= demand_p[p]
);

% Sulfur constraints: sum(s_r * x_rp) <= Smax_p * total
constraint forall(p in P) (
  sum(r in RM)(sulfur_rm_pm[r] * x[r,p]) <= sulfur_max_pm[p] * prod[p]
);

% Limited supply of raw material D (r=4)
constraint sum(p in P)(x[4,p]) <= D_supply_max;

% Profit definition (all integer arithmetic)
constraint profit_c =
  sum(p in P)(price_p_c[p] * prod[p])
  - sum(r in RM, p in P)(cost_rm_c[r] * x[r,p]);

%%%%%%%%%%%%
% Objective
%%%%%%%%%%%%
solve maximize profit_c;

%%%%%%%%%%%%
% Output
%%%%%%%%%%%%
output [
  "profit (thousand yuan) = ", show(profit_c / 100.0), "\n",
  "prodA = ", show(prod[1]), " tons\n",
  "prodB = ", show(prod[2]), " tons\n",
  "x (tons) rows RM(A,B,C,D) cols Prod(A,B):\n",
  concat([ concat([ show(x[r,p]) ++ if p==2 then "\n" else " " endif
                  | p in P ])
          | r in RM ])
];