int: N;
set of int: SHARES = 1..N;

array[SHARES] of float: Bought;
array[SHARES] of float: BuyPrice;
array[SHARES] of float: CurrentPrice;
array[SHARES] of float: FuturePrice;

float: TransactionRate;
float: TaxRate;

float: K;

array[SHARES] of var float: Sell;
array[SHARES] of var float: Remaining;

var float: NetRaised;

constraint forall(i in SHARES) (Sell[i] >= 0.0);
constraint forall(i in SHARES) (Sell[i] <= Bought[i]);

constraint forall(i in SHARES) (Remaining[i] = Bought[i] - Sell[i]);

constraint
  NetRaised =
    sum(i in SHARES)(
      let {
        var float: proceeds = Sell[i] * CurrentPrice[i];
        var float: trans_cost = proceeds * (TransactionRate / 100.0);
        var float: gain = Sell[i] * (CurrentPrice[i] - BuyPrice[i])
      } in
        proceeds
        - trans_cost
        - (TaxRate / 100.0) * max(gain, 0.0)
    );

constraint NetRaised >= K;

solve maximize sum(i in SHARES)(Remaining[i] * FuturePrice[i]);