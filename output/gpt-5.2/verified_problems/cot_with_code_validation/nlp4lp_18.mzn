% Portfolio liquidation with transaction costs and capital gains tax
% Parameters
int: N;
array[1..N] of float: Bought;
array[1..N] of float: BuyPrice;
array[1..N] of float: CurrentPrice;
array[1..N] of float: FuturePrice;
float: TransactionRate; % percent, e.g., 1.0 = 1%
float: TaxRate;         % percent, e.g., 15.0 = 15%
float: K;

% Variables (shares can be fractional)
array[1..N] of var float: Sell;
var float: netRaised;
var float: futureValue;

% Constraints
constraint forall(i in 1..N) (
  Sell[i] >= 0.0 /\ Sell[i] <= Bought[i]
);

% Net cash raised from selling, after transaction costs and capital gains tax
% gain per share = max(CurrentPrice - BuyPrice, 0)
constraint netRaised =
  sum(i in 1..N) (
    let {
      float: gain_per_share = max(CurrentPrice[i] - BuyPrice[i], 0.0)
    } in
      Sell[i] * (
        CurrentPrice[i]
        - (TransactionRate / 100.0) * CurrentPrice[i]
        - (TaxRate / 100.0) * gain_per_share
      )
  );

constraint netRaised >= K;

% Expected portfolio value next year (remaining shares)
constraint futureValue =
  sum(i in 1..N) ((Bought[i] - Sell[i]) * FuturePrice[i]);

% Objective
solve maximize futureValue;