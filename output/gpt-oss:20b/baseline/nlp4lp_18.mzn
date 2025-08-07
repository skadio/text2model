% ------------------------------------------------------------------
%  Investor – sell‑off optimisation
% ------------------------------------------------------------------
%  Parameters (to be supplied by a .dzn file)
int: N;                                 % number of securities

array[1..N] of float:  BuyPrice;        % price at which the security was bought
array[1..N] of float:  CurrentPrice;    % current market price
array[1..N] of float:  Shares;          % number of shares owned

float:  TransactionFee;                 % fixed fee per transaction
float:  TaxRate;                        % tax rate on capital gains (e.g. 0.15 for 15%)

float:  NetProfitTarget;                % required net profit (positive number)

% ------------------------------------------------------------------
%  Decision variables
% ------------------------------------------------------------------
var 0.0 .. 1.0:  SellFraction[1..N];    % fraction of each security to sell

% ------------------------------------------------------------------
%  Derived quantities
% ------------------------------------------------------------------
array[1..N] of float:  GainPerShare =
   (CurrentPrice - BuyPrice) * (1.0 - TransactionFee / CurrentPrice);

array[1..N] of float:  TaxPerShare =
   max(0.0, (CurrentPrice - BuyPrice)) * TaxRate;

array[1..N] of float:  NetGainPerShare =
   GainPerShare - TaxPerShare;

array[1..N] of float:  NetGain =
   NetGainPerShare * Shares * SellFraction;

array[1..N] of float:  NetLoss =
   max(0.0, -NetGainPerShare) * Shares * SellFraction;

% ------------------------------------------------------------------
%  Constraints
% ------------------------------------------------------------------
constraint
   sum(NetGain) - sum(NetLoss) >= NetProfitTarget;

% ------------------------------------------------------------------
%  Objective – maximise the expected future value of the remaining
%  portfolio (i.e. minimise the amount sold)
% ------------------------------------------------------------------
var float: RemainingValue =
   sum((1.0 - SellFraction[i]) * CurrentPrice[i] * Shares[i]
       | i in 1..N);

solve maximize RemainingValue;

% ------------------------------------------------------------------
%  Output
% ------------------------------------------------------------------
output [
   "Sell fractions: ", show(SellFraction), "\n",
   "Net profit achieved: ", show(sum(NetGain) - sum(NetLoss)), "\n",
   "Remaining portfolio value: ", show(RemainingValue), "\n"
];