% Portfolio liquidation with transaction costs and capital gains tax
% Maximize expected portfolio value next year while raising at least K net cash.

include "globals.mzn";

int: N;

array[1..N] of float: Bought;        % initial shares held
array[1..N] of float: BuyPrice;      % purchase price per share
array[1..N] of float: CurrentPrice;  % current price per share
array[1..N] of float: FuturePrice;   % expected future price per share

float: TransactionRate;  % percent (e.g., 1.0 means 1%)
float: TaxRate;          % percent (e.g., 15.0 means 15%)
float: K;                % required net cash to raise

float: tr = TransactionRate / 100.0;
float: tax = TaxRate / 100.0;

% Decision: shares to sell (continuous)
array[1..N] of var float: sell;

% Remaining shares after selling
array[1..N] of var float: remain;

constraint forall(i in 1..N) (
  sell[i] >= 0.0 /\
  sell[i] <= Bought[i] /\
  remain[i] = Bought[i] - sell[i]
);

% Cash received from sales minus transaction costs
var float: grossProceeds = sum(i in 1..N)( sell[i] * CurrentPrice[i] );
var float: transactionCost = tr * grossProceeds;
var float: netProceedsBeforeTax = grossProceeds - transactionCost;

% Capital gains tax on profits only (no tax credit for losses)
array[1..N] of var float: gain;
array[1..N] of var float: taxableGain;

constraint forall(i in 1..N) (
  gain[i] = sell[i] * (CurrentPrice[i] - BuyPrice[i]) /\
  taxableGain[i] >= gain[i] /\
  taxableGain[i] >= 0.0
);

var float: totalTaxableGain = sum(i in 1..N)( taxableGain[i] );
var float: taxPaid = tax * totalTaxableGain;

% Net cash raised constraint
var float: netCash = netProceedsBeforeTax - taxPaid;
constraint netCash >= K;

% Objective: maximize expected portfolio value next year (remaining shares)
var float: futureValue = sum(i in 1..N)( remain[i] * FuturePrice[i] );

solve maximize futureValue;

output [
  "sell = ", show(sell), "\n",
  "remain = ", show(remain), "\n",
  "grossProceeds = ", show(grossProceeds), "\n",
  "transactionCost = ", show(transactionCost), "\n",
  "totalTaxableGain = ", show(totalTaxableGain), "\n",
  "taxPaid = ", show(taxPaid), "\n",
  "netCash = ", show(netCash), "\n",
  "futureValue = ", show(futureValue), "\n"
];