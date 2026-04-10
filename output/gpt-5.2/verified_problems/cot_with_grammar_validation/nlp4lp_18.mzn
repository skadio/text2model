int: N;
set of int: SHARES = 1..N;

array[SHARES] of float: Bought;
array[SHARES] of float: BuyPrice;
array[SHARES] of float: CurrentPrice;
array[SHARES] of float: FuturePrice;

float: TransactionRate;
float: TaxRate;
float: K;

float: tr = TransactionRate / 100.0;
float: tax = TaxRate / 100.0;

array[SHARES] of var float: Sell;

constraint forall(i in SHARES) (Sell[i] >= 0.0);
constraint forall(i in SHARES) (Sell[i] <= Bought[i]);

constraint
  sum(i in SHARES)(
      Sell[i] * CurrentPrice[i]
    - tr * Sell[i] * CurrentPrice[i]
    - tax * Sell[i] * (if CurrentPrice[i] - BuyPrice[i] > 0.0 then CurrentPrice[i] - BuyPrice[i] else 0.0 endif)
  ) >= K;

solve maximize sum(i in SHARES)((Bought[i] - Sell[i]) * FuturePrice[i]);