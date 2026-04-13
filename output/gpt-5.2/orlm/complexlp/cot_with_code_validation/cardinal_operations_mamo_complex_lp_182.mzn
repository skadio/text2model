% Fruit salad production (integer units)

% Sets
int: nProd = 2;
set of int: PROD = 1..nProd;

int: nRes = 3;
set of int: RES = 1..nRes;

% Resource indices: 1=mango, 2=pineapple, 3=strawberry
array[RES] of int: stock = [25, 10, 120];

% Scale by 8 to eliminate fractions:
% A uses (1/4, 1/8, 3) -> (2, 1, 24)
% B uses (1/2, 1/4, 1) -> (4, 2, 8)
array[RES, PROD] of int: use8 = array2d(RES, PROD,
  [
    2, 4,    % mango:      A, B
    1, 2,    % pineapple:  A, B
    24, 8    % strawberry: A, B
  ]
);

array[RES] of int: stock8 = [stock[1]*8, stock[2]*8, stock[3]*8];
array[PROD] of int: profit = [10, 20];

int: slack = 5;
int: slack8 = slack * 8;

% Decision variables (integer number of salads)
array[PROD] of var int: x;

array[RES] of var int: diff8;
var int: total_profit;

% Constraints
constraint forall(p in PROD)(x[p] >= 0);

constraint forall(r in RES)(
  diff8[r] = stock8[r] - sum(p in PROD)(use8[r,p] * x[p])
);

% Allow at most 5 units leftover or 5 units extra used (scaled)
constraint forall(r in RES)(
  diff8[r] >= -slack8 /\ diff8[r] <= slack8
);

constraint total_profit = sum(p in PROD)(profit[p] * x[p]);

% Objective type requested: satisfaction
solve satisfy;

output [
  "xA=", show(x[1]), " xB=", show(x[2]), "\n",
  "profit=", show(total_profit), "\n",
  "diff_mango=", show(diff8[1]/8.0), " diff_pineapple=", show(diff8[2]/8.0),
  " diff_strawberry=", show(diff8[3]/8.0), "\n"
];