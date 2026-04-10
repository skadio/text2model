% Portfolio liquidation with transaction costs and capital gains tax
% Uses bounded float variables to avoid Gecode "Float::linear: Number out of limits"

% Parameters
int: N;
set of int: SHARES = 1..N;

array[SHARES] of float: Bought;
array[SHARES] of float: BuyPrice;
array[SHARES] of float: CurrentPrice;
array[SHARES] of float: FuturePrice;

float: TransactionRate;   % percentage, e.g. 1.0
float: TaxRate;           % percentage, e.g. 15.0
float: K;                 % cash to raise (net)

% Helper bounds to keep float linear constraints within solver limits
float: maxBought = max(i in SHARES)(Bought[i]);
float: maxBuyP   = max(i in SHARES)(BuyPrice[i]);
float: maxCurP   = max(i in SHARES)(CurrentPrice[i]);
float: maxFutP   = max(i in SHARES)(FuturePrice[i]);

float: maxGross  = maxBought * maxCurP;
float: maxGain   = maxBought * max(0.0, maxCurP - min(i in SHARES)(BuyPrice[i]));
float: maxTax    = maxGain * (TaxRate / 100.0);
float: maxTCost  = maxGross * (TransactionRate / 100.0);
float: maxNetOne = maxGross; % conservative
float: maxNetTot = N * maxNetOne;

float: maxFutTot = N * (maxBought * maxFutP);

% Variables (bounded)
array[SHARES] of var 0.0..maxBought: Sell;
array[SHARES] of var 0.0..maxBought: Remaining;

array[SHARES] of var 0.0..maxGross: GrossProceeds;
array[SHARES] of var 0.0..maxTCost: TransactionCost;

array[SHARES] of var (-maxGain)..maxGain: CapitalGain;
array[SHARES] of var 0.0..maxGain: TaxableGain;
array[SHARES] of var 0.0..maxTax: TaxPaid;

var 0.0..maxNetTot: NetRaised;
var 0.0..maxFutTot: ExpectedFutureValue;

% Constraints
constraint forall(i in SHARES) (
  Sell[i] <= Bought[i] /\
  Remaining[i] = Bought[i] - Sell[i]
);

constraint forall(i in SHARES) (
  GrossProceeds[i] = Sell[i] * CurrentPrice[i] /\
  TransactionCost[i] = GrossProceeds[i] * (TransactionRate / 100.0) /\
  CapitalGain[i] = Sell[i] * (CurrentPrice[i] - BuyPrice[i]) /\
  TaxableGain[i] >= CapitalGain[i] /\
  TaxableGain[i] >= 0.0 /\
  TaxPaid[i] = TaxableGain[i] * (TaxRate / 100.0)
);

constraint NetRaised = sum(i in SHARES) (GrossProceeds[i] - TransactionCost[i] - TaxPaid[i]);
constraint NetRaised >= K;

constraint ExpectedFutureValue = sum(i in SHARES) (Remaining[i] * FuturePrice[i]);

solve maximize ExpectedFutureValue;