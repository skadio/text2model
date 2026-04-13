int: N;

array[1..N] of float: Bought;
array[1..N] of float: BuyPrice;
array[1..N] of float: CurrentPrice;
array[1..N] of float: FuturePrice;

float: TransactionRate; % given in percent, e.g., 1.0 means 1%
float: TaxRate;         % given in percent, e.g., 15.0 means 15%
float: K;

float: tr = TransactionRate / 100.0;
float: tax = TaxRate / 100.0;

array[1..N] of var float: Sell;

constraint forall(i in 1..N) (
  0.0 <= Sell[i] /\ Sell[i] <= Bought[i]
);

array[1..N] of var float: Gross;
array[1..N] of var float: TransCost;
array[1..N] of var float: Gain;
array[1..N] of var float: TaxPaid;
array[1..N] of var float: NetProceeds;

constraint forall(i in 1..N) (
  Gross[i] = Sell[i] * CurrentPrice[i] /\
  TransCost[i] = tr * Gross[i] /\
  Gain[i] = Sell[i] * (CurrentPrice[i] - BuyPrice[i]) /\
  TaxPaid[i] >= 0.0 /\
  TaxPaid[i] >= tax * Gain[i] /\
  NetProceeds[i] = Gross[i] - TransCost[i] - TaxPaid[i]
);

constraint sum(i in 1..N)(NetProceeds[i]) >= K;

var float: ExpectedValueNextYear =
  sum(i in 1..N)((Bought[i] - Sell[i]) * FuturePrice[i]);

solve maximize ExpectedValueNextYear;

output [
  "Sell = ", show(Sell), "\n",
  "ExpectedValueNextYear = ", show(ExpectedValueNextYear), "\n",
  "NetRaised = ", show(sum(i in 1..N)(NetProceeds[i])), "\n"
];