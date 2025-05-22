% Parameters
int: N;
array[1..N] of float: Bought;
array[1..N] of float: BuyPrice;
array[1..N] of float: CurrentPrice;
array[1..N] of float: FuturePrice;
float: TransactionRate;          % percentage, e.g., 1.0 means 1 %
float: TaxRate;                  % percentage, e.g., 15.0 means 15 %
float: K;                        % cash the investor needs to raise

% Derived constants
float: transRate = TransactionRate / 100.0;
float: taxRate   = TaxRate / 100.0;
array[1..N] of float: positiveGain =
  [ max(0.0, CurrentPrice[i] - BuyPrice[i]) | i in 1..N ];
float: maxBought = max(Bought);

% Variables
array[1..N] of var 0.0..maxBought: Sell;   % number of shares to sell

% Constraints
constraint
  forall(i in 1..N) (
    Sell[i] <= Bought[i]               % cannot sell more than owned
  );

var float: netCash =
  sum(i in 1..N)(
       Sell[i] * CurrentPrice[i] * (1.0 - transRate)   % after transaction cost
     - taxRate * Sell[i] * positiveGain[i]             % minus tax on gains
  );

constraint
  netCash >= K;                                        % cash requirement

% Objective
var float: futureValue =
  sum(i in 1..N)(
      (Bought[i] - Sell[i]) * FuturePrice[i]           % expected value next year
  );

solve maximize futureValue;