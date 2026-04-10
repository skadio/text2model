include "globals.mzn";

% Data (embedded as requested)
int: maxBonds  = 10000;
int: maxStocks = 5000;

int: riskBond1  = 2;
int: riskBond2  = 3;
int: riskStock1 = 4;
int: riskStock2 = 5;

int: diffBond1Stock1 = 2000;  % Bond1 >= Stock1 + 2000
int: diffStock2Bond2 = 1000;  % Stock2 >= Bond2 + 1000

% NOTE: The statement mentions "individual bounds on investments for each asset type"
% but does not provide them. We therefore model investments as nonnegative integers.
% If additional per-asset bounds exist, add them here.
array[1..4] of string: asset = ["Bond1","Bond2","Stock1","Stock2"];

% Decision variables: amounts invested (in dollars)
var 0..maxBonds:  bond1;
var 0..maxBonds:  bond2;
var 0..maxStocks: stock1;
var 0..maxStocks: stock2;

% Constraints
constraint bond1 + bond2 <= maxBonds;
constraint stock1 + stock2 <= maxStocks;

constraint bond1 >= stock1 + diffBond1Stock1;
constraint stock2 >= bond2 + diffStock2Bond2;

% Objective: minimize total risk score (risk units per dollar invested)
var int: total_risk = riskBond1 * bond1
                   + riskBond2 * bond2
                   + riskStock1 * stock1
                   + riskStock2 * stock2;

solve minimize total_risk;

output [
  "Bond1 = ", show(bond1), "\n",
  "Bond2 = ", show(bond2), "\n",
  "Stock1 = ", show(stock1), "\n",
  "Stock2 = ", show(stock2), "\n",
  "Total risk (min) = ", show(total_risk), "\n",
  "Rounded total risk = ", show(total_risk), "\n"
];