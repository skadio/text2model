% MiniZinc model for the investment optimisation problem
% -------------------------------------------------------

% Input data (to be supplied via a .dzn file)
int: N;                                   % number of stocks
array[1..N] of int: Bought;               % shares initially bought
array[1..N] of int: BuyPrice;             % purchase price per share
array[1..N] of int: CurrentPrice;         % current market price per share
array[1..N] of int: FuturePrice;          % expected price after one year
float: TransactionRate;                   % transaction cost rate (%) per share sold
float: TaxRate;                           % capital‑gain tax rate (%) on profit
int: K;                                   % amount of money that must be raised (net)

% Decision variables
array[1..N] of var float: sell;           % number of shares sold (can be fractional)

% Bounds on selling: cannot sell more than owned, cannot sell negative amounts
constraint
  forall(i in 1..N) (
    sell[i] >= 0.0 /\ sell[i] <= float(Bought[i])
  );

% Net money raised after transaction costs and taxes
var float: netRaised = sum(i in 1..N) (
  sell[i] * ( CurrentPrice[i] * (1.0 - TransactionRate/100.0)
              - (CurrentPrice[i] - BuyPrice[i]) * TaxRate/100.0 )
);

% Expected value of the remaining portfolio after one year
var float: expectedValue = sum(i in 1..N) (
  (float(Bought[i]) - sell[i]) * FuturePrice[i]
);

% Constraint: must raise at least the required amount
constraint netRaised >= float(K);

% Objective: maximise the expected future value of the portfolio
solve maximize expectedValue;

% Output results
output [
  "Sell = ", show(sell), "\n",
  "Net raised = ", show(netRaised), "\n",
  "Expected future value = ", show(expectedValue), "\n"
];