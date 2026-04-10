% Parameters
int: N;
set of int: SHARES = 1..N;

array[SHARES] of float: Bought;
array[SHARES] of float: BuyPrice;
array[SHARES] of float: CurrentPrice;
array[SHARES] of float: FuturePrice;

float: TransactionRate; % percent (e.g., 1.0 means 1%)
float: TaxRate;         % percent (e.g., 15.0 means 15%)
float: K;

% Variables
array[SHARES] of var float: Sell;
array[SHARES] of var float: Hold;

var float: NetRaised;
var float: ExpectedFutureValue;

% Constraints
constraint forall(i in SHARES) (Sell[i] >= 0.0);
constraint forall(i in SHARES) (Sell[i] <= Bought[i]);
constraint forall(i in SHARES) (Hold[i] = Bought[i] - Sell[i]);

% Net money raised now (after transaction costs and capital-gains taxes)
% Transaction cost: TransactionRate% of sale proceeds
% Capital gains tax: TaxRate% of max(0, proceeds - cost basis)
constraint
  NetRaised =
    sum(i in SHARES) (
      CurrentPrice[i] * Sell[i]
      - (TransactionRate/100.0) * CurrentPrice[i] * Sell[i]
      - (TaxRate/100.0) * max(0.0, (CurrentPrice[i] - BuyPrice[i]) * Sell[i])
    );

constraint NetRaised >= K;

% Expected portfolio value next year (of remaining shares)
constraint
  ExpectedFutureValue = sum(i in SHARES) (FuturePrice[i] * Hold[i]);

% Objective
solve maximize ExpectedFutureValue;