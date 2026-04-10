int: K;
int: MaxWork;

array[1..K] of float: Royalty;
array[1..K] of float: Limit;
array[1..K] of float: Quality;

int: I;
array[1..I] of float: RequiredQuality;

float: Price;
float: Discount;

set of int: MINES = 1..K;
set of int: YEARS = 1..I;

% Decision variables
array[YEARS, MINES] of var bool: work;        % mine k operated in year i
array[YEARS, MINES] of var bool: open;        % mine k kept open in year i (royalty paid)
array[YEARS, MINES] of var float: prod;       % production from mine k in year i

% Discount factor per year i (year 1 undiscounted)
array[YEARS] of float: df = [ 1.0 / pow(1.0 + Discount, i-1) | i in YEARS ];

% Operational constraints
constraint
  forall(i in YEARS) (
    sum(k in MINES)(bool2int(work[i,k])) <= MaxWork
  );

% Production only if worked; production limit
constraint
  forall(i in YEARS, k in MINES) (
    prod[i,k] >= 0.0 /\
    prod[i,k] <= Limit[k] * bool2int(work[i,k])
  );

% If worked then must be open (and royalties paid); open is nonincreasing over years (can permanently close)
constraint
  forall(i in YEARS, k in MINES) (
    bool2int(open[i,k]) >= bool2int(work[i,k])
  );

constraint
  forall(i in 1..I-1, k in MINES) (
    bool2int(open[i,k]) >= bool2int(open[i+1,k])
  );

% Blending quality constraint each year:
% (sum_k prod[i,k] * Quality[k]) / (sum_k prod[i,k]) = RequiredQuality[i]
% Implemented as equality: sum_k prod[i,k]*(Quality[k]-RequiredQuality[i]) = 0
constraint
  forall(i in YEARS) (
    sum(k in MINES)( prod[i,k] * (Quality[k] - RequiredQuality[i]) ) = 0.0
  );

% Require positive total production each year (otherwise quality constraint is degenerate)
constraint
  forall(i in YEARS) (
    sum(k in MINES)(prod[i,k]) > 0.0
  );

% Objective: discounted profit = discounted revenue - discounted royalties
var float: total_profit =
  sum(i in YEARS)(
    df[i] * (
      Price * sum(k in MINES)(prod[i,k])
      - sum(k in MINES)(Royalty[k] * bool2int(open[i,k]))
    )
  );

solve maximize total_profit;

output [
  "total_profit=", show(total_profit), "\n",
  "work=\n", show(work), "\n",
  "open=\n", show(open), "\n",
  "prod=\n", show(prod), "\n"
];