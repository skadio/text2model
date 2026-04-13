% Blending / mixing optimization (linear programming)
% Data is embedded as requested.

% We use floats and solve with a MIP/LP-capable solver.
% Variables represent tons.

% ---------- Data ----------
set of int: RM = 1..4;          % raw materials: 1=A, 2=B, 3=C, 4=D
set of int: P  = 1..2;          % products: 1=ProdA, 2=ProdB

array[RM] of float: sulfur = [3.0, 1.0, 2.0, 1.0];          % %
array[RM] of float: buy    = [6.0, 16.0, 10.0, 15.0];       % kYuan/ton

array[P] of float: maxS = [2.5, 1.5];                       % % for products A,B
array[P] of float: demand = [100.0, 200.0];                 % tons demanded (max producible)
array[P] of float: sell = [9.15, 9.15];                     % kYuan/ton

float: D_max = 50.0;                                        % tons

% ---------- Decision variables ----------
% x[r,p] = tons of raw material r used in product p
array[RM, P] of var float: x;

% production quantities
array[P] of var float: q;

% ---------- Domains / nonnegativity ----------
constraint forall(r in RM, p in P)( x[r,p] >= 0.0 );
constraint forall(p in P)( q[p] >= 0.0 );

% ---------- Linking: production equals sum of ingredients ----------
constraint forall(p in P)(
  q[p] = sum(r in RM)( x[r,p] )
);

% ---------- Demand limits ----------
constraint forall(p in P)( q[p] <= demand[p] );

% ---------- Supply limit for raw material D ----------
constraint sum(p in P)( x[4,p] ) <= D_max;

% ---------- Sulfur constraints (weighted average) ----------
% (sum sulfur_i * x_i) / q <= maxS  => sum sulfur_i * x_i <= maxS * q
constraint forall(p in P)(
  sum(r in RM)( sulfur[r] * x[r,p] ) <= maxS[p] * q[p]
);

% ---------- Objective: maximize profit ----------
% profit = revenue - purchase cost
var float: revenue = sum(p in P)( sell[p] * q[p] );
var float: cost    = sum(r in RM, p in P)( buy[r] * x[r,p] );
var float: profit  = revenue - cost;

solve maximize profit;

output [
  "Profit (kYuan) = ", show(profit), "\n",
  "Revenue (kYuan) = ", show(revenue), "\n",
  "Cost (kYuan) = ", show(cost), "\n\n",
  "Production (tons):\n",
  "  ProdA = ", show(q[1]), "\n",
  "  ProdB = ", show(q[2]), "\n\n",
  "Raw material usage x[r,p] (tons):\n",
  "  For ProdA: A=", show(x[1,1]), " B=", show(x[2,1]), " C=", show(x[3,1]), " D=", show(x[4,1]), "\n",
  "  For ProdB: A=", show(x[1,2]), " B=", show(x[2,2]), " C=", show(x[3,2]), " D=", show(x[4,2]), "\n",
  "\nTotal D used = ", show(x[4,1] + x[4,2]), " (<= ", show(D_max), ")\n"
];