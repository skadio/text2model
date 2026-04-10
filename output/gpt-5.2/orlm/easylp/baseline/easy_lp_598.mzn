% Portfolio allocation with minimum risk (all values in thousand dollars, integer)

int: riskStocks = 3;
int: riskBonds = 4;
int: riskMutual = 2;
int: riskDeriv = 5;

int: minStocksBonds = 1000;
int: maxDiffMutualDeriv = 500;
int: minStocksOverMutual = 200;
int: bondsDerivSum = 1500;

% Decision variables: investments in K$
var 0..100000: S; % Stocks
var 0..100000: B; % Bonds
var 0..100000: M; % Mutual Funds
var 0..100000: D; % Derivatives

constraint S + B >= minStocksBonds;
constraint abs(M - D) <= maxDiffMutualDeriv;
constraint S - M >= minStocksOverMutual;
constraint B + D = bondsDerivSum;

var int: total_risk = riskStocks*S + riskBonds*B + riskMutual*M + riskDeriv*D;

solve minimize total_risk;

% The objective is already an integer, so rounding is exact.
output [
  "Minimum total risk score (rounded) = ", show(total_risk), "\n",
  "Optimal allocations (K$): S=", show(S), " B=", show(B), " M=", show(M), " D=", show(D), "\n"
];