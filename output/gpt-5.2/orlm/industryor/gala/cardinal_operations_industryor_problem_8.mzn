include "globals.mzn";

% Products: 1=truck, 2=airplane, 3=boat, 4=train
set of int: P = 1..4;

array[P] of int: profit = [5, 10, 8, 7];

int: wood_avail = 890;
array[P] of int: wood_req = [12, 20, 15, 10];

int: steel_avail = 500;
array[P] of int: steel_req = [6, 3, 5, 4];

% Decision variables: quantity produced of each product
array[P] of var 0..wood_avail: x;

% Indicator whether a product type is manufactured (>0)
array[P] of var 0..1: make;

% Link make <-> x (tight enough for this data)
constraint forall(p in P)(
  x[p] <= wood_avail * make[p] / min(1, wood_req[p]) % min() avoids div by 0 (not needed here)
);
constraint forall(p in P)(
  x[p] >= make[p]
);

% Resource constraints
constraint sum(p in P)(wood_req[p] * x[p]) <= wood_avail;
constraint sum(p in P)(steel_req[p] * x[p]) <= steel_avail;

% Logical constraints
% If manufacture trucks, do not manufacture trains
constraint make[1] + make[4] <= 1;

% If manufacture boats, also manufacture airplanes
constraint make[3] <= make[2];

% Boats cannot exceed trains
constraint x[3] <= x[4];

% Objective: maximize total profit
var int: total_profit = sum(p in P)(profit[p] * x[p]);

solve maximize total_profit;

output [
  "Quantities (truck, airplane, boat, train) = ", show([x[1], x[2], x[3], x[4]]), "\n",
  "Manufactured types (1=yes)               = ", show([make[1], make[2], make[3], make[4]]), "\n",
  "Total profit = ", show(total_profit), "\n",
  "Wood used  = ", show(sum(p in P)(wood_req[p] * x[p])), " / ", show(wood_avail), "\n",
  "Steel used = ", show(sum(p in P)(steel_req[p] * x[p])), " / ", show(steel_avail), "\n"
];