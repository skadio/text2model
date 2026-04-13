include "globals.mzn";

/***** INPUT DATA *****/
int: K;                         % number of mines
int: T;                         % number of years (must be provided in .dzn)
int: MaxWork;                   % maximum mines that can be operated in a year

array[1..K] of float: Royalty;  % yearly royalty payable if mine is kept open (see open/close logic)
array[1..K] of float: Limit;    % max production per year for mine k
array[1..K] of float: Quality;  % ore quality from mine k

array[1..T] of float: RequiredQuality;  % required blended quality each year
float: Price;                              % price per ton
float: Discount;                           % discount rate per annum (e.g., 0.1)

/***** DERIVED CONSTANTS *****/
array[1..T] of float: disc = [ 1.0 / pow(1.0 + Discount, float(t-1)) | t in 1..T ];

/***** DECISION VARIABLES *****/
array[1..T, 1..K] of var 0..1: operate;      % 1 if mine k is operated in year t
array[1..T, 1..K] of var 0.0..1.0: frac;     % fraction of yearly limit extracted (continuous)
array[1..T, 1..K] of var 0.0..1.0: open;     % 1 if mine is kept open (royalty paid) in year t

/***** CONSTRAINTS *****/

% At most MaxWork mines can be operated each year
constraint
  forall(t in 1..T)(
    count([operate[t,k] | k in 1..K], 1, var int: c) /\ c <= MaxWork
  );

% Link production fraction to operation
constraint forall(t in 1..T, k in 1..K)(
  frac[t,k] <= operate[t,k]
);

% "Open" logic: if operated in any future year, mine must be open now.
% open[t,k] = max_{u=t..T} operate[u,k]
constraint forall(k in 1..K, t in 1..T)(
  open[t,k] >= operate[t,k]
);
constraint forall(k in 1..K, t in 1..T-1)(
  open[t,k] >= open[t+1,k]
);
constraint forall(k in 1..K)(
  open[T,k] = operate[T,k]
);

% Blended quality each year must equal RequiredQuality[t]:
% sum(q_k * x_k) = RQ * sum(x_k) where x_k = frac*Limit
constraint forall(t in 1..T)(
  sum(k in 1..K)(Quality[k] * Limit[k] * frac[t,k])
  =
  RequiredQuality[t] * sum(k in 1..K)(Limit[k] * frac[t,k])
);

/***** OBJECTIVE: MAXIMIZE DISCOUNTED PROFIT *****/
var float: discounted_profit =
  sum(t in 1..T)(
    disc[t] * (
      Price * sum(k in 1..K)(Limit[k] * frac[t,k])
      - sum(k in 1..K)(Royalty[k] * open[t,k])
    )
  );

solve maximize discounted_profit;

/***** OUTPUT *****/
output [
  "DiscountedProfit = ", show(discounted_profit), "\n",
  "operate = ", show(operate), "\n",
  "frac = ", show(frac), "\n",
  "open = ", show(open), "\n",
  "ProductionPerYear = ", show([ sum(k in 1..K)(Limit[k]*frac[t,k]) | t in 1..T ]), "\n"
];