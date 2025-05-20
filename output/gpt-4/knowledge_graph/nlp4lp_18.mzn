include "globals.mzn";

% Parameters
int: N; % Number of different shares
array[1..N] of float: Bought; % Amount of each share initially bought
array[1..N] of float: BuyPrice; % Purchase price of each share
array[1..N] of float: CurrentPrice; % Current market price of each share
array[1..N] of float: FuturePrice; % Expected future market price of each share
float: TransactionRate; % Transaction cost rate per share sold
float: TaxRate; % Capital gains tax rate on the profit from selling shares
float: K; % Amount of money the investor needs to raise

% Variables
array[1..N] of var 0.0..Bought[i]: Sold; % Amount of each share to sell

% Constraints
constraint forall(i in 1..N) (
    Sold[i] <= Bought[i]
);

constraint sum(i in 1..N) (
    (CurrentPrice[i] - TransactionRate * CurrentPrice[i]) * Sold[i] - 
    max(0.0, (CurrentPrice[i] - BuyPrice[i]) * Sold[i] * TaxRate / 100.0)
) >= K;

% Objective
var float: FutureValue = sum(i in 1..N) (FuturePrice[i] * (Bought[i] - Sold[i]));
solve maximize FutureValue;

% Output
output ["FutureValue: ", show(FutureValue), "\n"] ++
["Shares to sell: "] ++ [show(Sold[i]) | i in 1..N];