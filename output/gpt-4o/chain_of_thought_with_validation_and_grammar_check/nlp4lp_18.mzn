int: N;
array[1..N] of float: Bought;
array[1..N] of float: BuyPrice;
array[1..N] of float: CurrentPrice;
array[1..N] of float: FuturePrice;
float: TransactionRate;   % percentage, e.g., 1.0 for 1 %
float: TaxRate;           % percentage, e.g., 15.0 for 15 %
float: K;                 % required net cash to raise

array[1..N] of float: NetPrice =
  [ CurrentPrice[i] * (1.0 - TransactionRate / 100.0)
    - (TaxRate / 100.0) *
      ( if CurrentPrice[i] > BuyPrice[i]
        then CurrentPrice[i] - BuyPrice[i]
        else 0.0 endif )
  | i in 1..N ];

array[1..N] of var float: Sell;   % number of shares to sell (can be fractional)

constraint
  forall(i in 1..N) (
    0.0 <= Sell[i] /\ Sell[i] <= Bought[i]
  );

constraint
  sum(i in 1..N) (Sell[i] * NetPrice[i]) >= K;

solve maximize
  sum(i in 1..N) ((Bought[i] - Sell[i]) * FuturePrice[i]);