include "globals.mzn";

/* Data (all amounts in thousand dollars, i.e., $K) */
int: rStocks = 3;
int: rBonds = 4;
int: rMutual = 2;
int: rDeriv = 5;

int: minStocksBonds = 1000;
int: maxDiffMutualDeriv = 500;
int: minStocksOverMutual = 200;
int: bondsPlusDeriv = 1500;

/* Decision variables: investments (in $K), whole numbers */
var 0..5000: Stocks;
var 0..5000: Bonds;
var 0..5000: MutualFunds;
var 0..5000: Derivatives;

/* Constraints */
constraint Stocks + Bonds >= minStocksBonds;
constraint abs(MutualFunds - Derivatives) <= maxDiffMutualDeriv;
constraint Stocks >= MutualFunds + minStocksOverMutual;
constraint Bonds + Derivatives = bondsPlusDeriv;

/* Objective: minimize total risk score */
var 0..100000: TotalRisk =
  rStocks * Stocks + rBonds * Bonds + rMutual * MutualFunds + rDeriv * Derivatives;

solve minimize TotalRisk;

/* Output: minimum total risk score (already integral, so rounding is trivial) */
output [
  "Minimum total risk score = ", show(TotalRisk), "\n",
  "Stocks(K) = ", show(Stocks), "\n",
  "Bonds(K) = ", show(Bonds), "\n",
  "MutualFunds(K) = ", show(MutualFunds), "\n",
  "Derivatives(K) = ", show(Derivatives), "\n"
];