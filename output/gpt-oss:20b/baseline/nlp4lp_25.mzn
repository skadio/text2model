int: K;
int: MaxWork;
array[1..K] of int: Royalty;
array[1..K] of int: Limit;
array[1..K] of float: Quality;
array[1..*] of float: RequiredQuality;
int: Price;
float: Discount;

int: I = length(RequiredQuality);

array[1..K, 1..I] of var 0..Limit[k]: produce;
array[1..K, 1..I] of var 0..1: operate;
array[1..K, 1..I] of var 0..1: open;

constraint
  % Production only when operated
  forall(k in 1..K, i in 1..I) (
    produce[k,i] <= Limit[k] * operate[k,i]
  ) /\

  % Limit number of mines operated per year
  forall(i in 1..I) (
    sum(k in 1..K) operate[k,i] <= MaxWork
  ) /\

  % Open status: if operated, must be open
  forall(k in 1..K, i in 1..I) (
    open[k,i] >= operate[k,i]
  ) /\

  % Open status persists until last operation
  forall(k in 1..K, i in 1..I-1) (
    open[k,i] >= open[k,i+1]
  ) /\

  forall(k in 1..K, i in 1..I-1) (
    open[k,i] <= open[k,i+1] + operate[k,i]
  ) /\

  % For last year, open equals operate
  forall(k in 1..K) (
    open[k,I] = operate[k,I]
  ) /\

  % Quality blending constraint
  forall(i in 1..I) (
    sum(k in 1..K) produce[k,i] * Quality[k] = RequiredQuality[i] * sum(k in 1..K) produce[k,i]
  );

% Objective: maximize discounted net profit
var float: totalProfit = sum(i in 1..I) (
  (float(Price) * sum(k in 1..K) float(produce[k,i]))
  - sum(k in 1..K) float(Royalty[k]) * float(open[k,i])
) / pow(1.0 + Discount, float(i));

solve maximize totalProfit;

output [
  "Total discounted profit: ", show(totalProfit), "\n",
  "Yearly production:\n",
  concat([ "Year ", show(i), ":\n",
           concat([ "  Mine ", show(k), ": ", show(produce[k,i]), "\n" | k in 1..K ])
         | i in 1..I ])
];