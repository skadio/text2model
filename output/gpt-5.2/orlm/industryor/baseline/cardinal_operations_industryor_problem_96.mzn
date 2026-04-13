% Blending with an intermediate mix:
% Stage 1: Mix raw materials A,B,D -> intermediate mix M
% Stage 2: Mix M with raw material C -> final products P1 (A) and P2 (B)

int: nR = 4; % raw materials: 1=A,2=B,3=C,4=D
set of int: R = 1..nR;
int: Araw = 1;
int: Braw = 2;
int: Craw = 3;
int: Draw = 4;

int: nP = 2; % products: 1=ProdA, 2=ProdB
set of int: P = 1..nP;
int: ProdA = 1;
int: ProdB = 2;

% Data
array[R] of float: sulfur = [0.03, 0.01, 0.02, 0.01];
array[R] of float: cost   = [6.0, 16.0, 10.0, 15.0]; % thousand yuan/ton

array[P] of float: maxSulfur = [0.025, 0.015]; % for products A,B
array[P] of float: demand    = [100.0, 200.0]; % tons
array[P] of float: price     = [9.15, 9.15];   % thousand yuan/ton

float: Dmax = 50.0;

% Decision variables (tons)
array[P] of var float: y;                 % production of each product
array[P] of var float: c_to_p;            % amount of raw C used in each product
array[P, 3] of var float: abd_to_p;        % amounts of A,B,D (after stage 1) allocated to each product
% abd_to_p[p,1]=A to product p, [p,2]=B to product p, [p,3]=D to product p

% Helper: total intermediate (A+B+D) sent to each product
array[P] of var float: m_to_p = [sum(i in 1..3)(abd_to_p[p,i]) | p in P];

% Bounds
constraint forall(p in P) (y[p] >= 0.0 /\ c_to_p[p] >= 0.0);
constraint forall(p in P, i in 1..3) (abd_to_p[p,i] >= 0.0);

% Demand limits (market demand caps)
constraint forall(p in P) (y[p] <= demand[p]);

% Mass balance to each product: (A+B+D) + C = product
constraint forall(p in P) (m_to_p[p] + c_to_p[p] = y[p]);

% Supply limit on raw material D
constraint sum(p in P)(abd_to_p[p,3]) <= Dmax;

% Sulfur constraints on final products
% sulfur_in_product = sulfurA*A + sulfurB*B + sulfurD*D + sulfurC*C <= maxSulfur * y
constraint forall(p in P)(
    sulfur[Araw]*abd_to_p[p,1]
  + sulfur[Braw]*abd_to_p[p,2]
  + sulfur[Draw]*abd_to_p[p,3]
  + sulfur[Craw]*c_to_p[p]
  <= maxSulfur[p] * y[p]
);

% Objective: maximize profit = revenue - raw material costs
var float: revenue = sum(p in P)(price[p] * y[p]);
var float: raw_cost =
    cost[Araw] * sum(p in P)(abd_to_p[p,1]) +
    cost[Braw] * sum(p in P)(abd_to_p[p,2]) +
    cost[Craw] * sum(p in P)(c_to_p[p]) +
    cost[Draw] * sum(p in P)(abd_to_p[p,3]);

var float: profit = revenue - raw_cost;

solve maximize profit;

output [
  "Profit (thousand yuan): ", show(profit), "\n",
  "Revenue (thousand yuan): ", show(revenue), "\n",
  "Raw material cost (thousand yuan): ", show(raw_cost), "\n\n",
  "Production (tons):\n",
  "  Product A: ", show(y[ProdA]), "\n",
  "  Product B: ", show(y[ProdB]), "\n\n",
  "Raw usage (tons):\n",
  "  A used: ", show(sum(p in P)(abd_to_p[p,1])), "\n",
  "  B used: ", show(sum(p in P)(abd_to_p[p,2])), "\n",
  "  C used: ", show(sum(p in P)(c_to_p[p])), "\n",
  "  D used: ", show(sum(p in P)(abd_to_p[p,3])), "\n\n",
  "Allocation to Product A (tons): A=", show(abd_to_p[ProdA,1]),
  " B=", show(abd_to_p[ProdA,2]),
  " D=", show(abd_to_p[ProdA,3]),
  " C=", show(c_to_p[ProdA]), "\n",
  "Allocation to Product B (tons): A=", show(abd_to_p[ProdB,1]),
  " B=", show(abd_to_p[ProdB,2]),
  " D=", show(abd_to_p[ProdB,3]),
  " C=", show(c_to_p[ProdB]), "\n"
];