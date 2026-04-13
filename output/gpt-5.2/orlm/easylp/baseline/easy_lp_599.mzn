int: n = 4;
set of int: I = 1..n;

% 1=stocks, 2=bonds, 3=mutual funds, 4=gold
array[I] of int: cost = [5, 6, 7, 8]; % cost per $1000 invested (units of $1000)

% Decision variables: invested amounts in $1000, integer units
array[I] of var int: x;

% Bounds (in $1000)
constraint x[1] >= 1 /\ x[1] <= 5; % stocks: $1000..$5000
constraint x[2] >= 1 /\ x[2] <= 3; % bonds:  $500..$3000 but integer $1000 => $1000..$3000
constraint x[3] >= 2;              % mutual funds: at least $2000
constraint x[4] >= 2;              % gold: at least $1500 but integer $1000 => at least $2000

% Additional constraints (all in $1000)
constraint abs(x[1] - x[2]) <= 5;  % difference <= $5000
constraint x[3] >= x[4] + 3;       % mutual funds at least $3000 more than gold
constraint x[1] + x[2] + x[3] + x[4] <= 10; % total <= $10000
constraint x[1] >= 2;              % minimum $2000 in stocks
constraint x[2] <= 4;              % maximum $4000 in bonds (redundant given x[2] <= 3)

var int: total_cost = sum(i in I)(cost[i] * x[i]); % in $1000 cost-units

solve minimize total_cost;

% Rounded to nearest thousand dollars:
% total_cost is already in $1000 cost-units, so report total_cost * 1000 dollars.
output [
  "stocks($): ", show(x[1]*1000), "\n",
  "bonds($): ", show(x[2]*1000), "\n",
  "mutual_funds($): ", show(x[3]*1000), "\n",
  "gold($): ", show(x[4]*1000), "\n",
  "min_total_cost($): ", show(total_cost*1000), "\n",
  "min_total_cost_rounded_to_nearest_1000($): ", show(total_cost*1000), "\n"
];