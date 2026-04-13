include "float.mzn";

int: K;                 % number of mines
int: MaxWork;           % max mines operated per year
array[1..K] of float: Royalty;
array[1..K] of float: Limit;
array[1..K] of float: Quality;

int: I;                 % number of years (length of planning horizon)
array[1..I] of float: RequiredQuality;

float: Price;
float: Discount;        % per annum discount rate

set of int: MINES = 1..K;
set of int: YEARS = 1..I;

array[YEARS, MINES] of var bool: MineOperation;
array[YEARS, MINES] of var float: Production;

% Discount factor for year t: 1/(1+Discount)^(t-1)
function float: disc(int: t) = 1.0 / pow(1.0 + Discount, int2float(t - 1));

% Maximum mines operated per year
constraint
  forall(t in YEARS)(
    sum(k in MINES)(bool2int(MineOperation[t,k])) <= MaxWork
  );

% Production only if operated, and within limit
constraint
  forall(t in YEARS, k in MINES)(
    0.0 <= Production[t,k] /\ Production[t,k] <= Limit[k] * bool2int(MineOperation[t,k])
  );

% Quality of blended ore must be exactly the required quality each year:
% sum_k qk*xk = ReqQ[t] * sum_k xk
constraint
  forall(t in YEARS)(
    sum(k in MINES)(Quality[k] * Production[t,k]) =
    RequiredQuality[t] * sum(k in MINES)(Production[t,k])
  );

% Objective: maximize discounted profit = discounted revenue - discounted royalties
var float: discounted_profit =
  sum(t in YEARS)(
    disc(t) * (
      Price * sum(k in MINES)(Production[t,k])
      - sum(k in MINES)(Royalty[k] * bool2int(MineOperation[t,k]))
    )
  );

solve maximize discounted_profit;

output [
  "discounted_profit=", show(discounted_profit), "\n",
  "MineOperation=\n", show(MineOperation), "\n",
  "Production=\n", show(Production), "\n"
];