% Fruit salad production optimization with near-complete resource usage

int: mango_stock = 25;
int: pineapple_stock = 10;
int: strawberry_stock = 120;

% Profit (RMB)
int: profitA = 10;
int: profitB = 20;

% Use integer arithmetic by scaling fractional fruit requirements
% Mango: 1/4 and 1/2 -> scale by 4
% Pineapple: 1/8 and 1/4 -> scale by 8

int: mangoScale = 4;
int: pineappleScale = 8;

% Scaled requirements
int: mangoReqA = 1;   % (1/4)*4
int: mangoReqB = 2;   % (1/2)*4
int: mangoAvail = mango_stock * mangoScale;

int: pineappleReqA = 1; % (1/8)*8
int: pineappleReqB = 2; % (1/4)*8
int: pineappleAvail = pineapple_stock * pineappleScale;

int: strawReqA = 3;
int: strawReqB = 1;
int: strawAvail = strawberry_stock;

int: tol = 5;

% Decision variables: number of salads A and B
var 0..10000: x1;
var 0..10000: x2;

% Resource usage expressions
var int: mangoUse = mangoReqA * x1 + mangoReqB * x2;
var int: pineappleUse = pineappleReqA * x1 + pineappleReqB * x2;
var int: strawUse = strawReqA * x1 + strawReqB * x2;

% Near-complete usage: allow at most 5 units left OR 5 additional used
% (interpreted as usage within +/- tol of available)
constraint abs(mangoUse - mangoAvail) <= tol * mangoScale;
constraint abs(pineappleUse - pineappleAvail) <= tol * pineappleScale;
constraint abs(strawUse - strawAvail) <= tol;

var int: totalProfit = profitA * x1 + profitB * x2;

solve maximize totalProfit;

output [
  "x1 (Salad A) = ", show(x1), "\n",
  "x2 (Salad B) = ", show(x2), "\n",
  "Total profit (RMB) = ", show(totalProfit), "\n",
  "Mango used = ", show(mangoUse), " / ", show(mangoAvail), " (scaled by 4)\n",
  "Pineapple used = ", show(pineappleUse), " / ", show(pineappleAvail), " (scaled by 8)\n",
  "Strawberries used = ", show(strawUse), " / ", show(strawAvail), "\n"
];