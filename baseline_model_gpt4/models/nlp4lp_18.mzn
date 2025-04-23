include "globals.mzn";

% Number of different shares
int: N;

% Amount of each share initially bought
array[1..N] of float: Bought;

% Purchase price of each share
array[1..N] of float: BuyPrice;

% Current market price of each share
array[1..N] of float: CurrentPrice;

% Expected future market price of each share
array[1..N] of float: FuturePrice;

% Transaction cost rate per share sold
float: TransactionRate;

% Capital gains tax rate on the profit from selling shares
float: TaxRate;

% Amount of money the investor needs to raise
float: K;

% Decision variable: number of shares to sell
array[1..N] of var 0.0..Bought[i]: Sell;

% Objective: maximize the expected value of portfolio next year
var float: FutureValue = sum(i in 1..N) ((Bought[i] - Sell[i]) * FuturePrice[i]);

% Constraints
constraint sum(i in 1..N) ((CurrentPrice[i] * Sell[i]) * (1 - TransactionRate) - max(0, (CurrentPrice[i] - BuyPrice[i]) * Sell[i] * TaxRate / 100)) >= K;

% Solve
solve maximize FutureValue;

% Output
output [ "Sell " ++ show(Sell[i]) ++ " shares of stock " ++ show(i) ++ "\n" | i in 1..N ];