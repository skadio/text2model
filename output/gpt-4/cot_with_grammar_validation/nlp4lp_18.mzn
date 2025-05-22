% Parameters
int: N;
array[1..N] of float: Bought;
array[1..N] of float: BuyPrice;
array[1..N] of float: CurrentPrice;
array[1..N] of float: FuturePrice;
float: TransactionRate;
float: TaxRate;
float: K;

% Variables
array[1..N] of var 0.0..max(Bought): Sold;

% Constraints
constraint forall(i in 1..N) (
    Sold[i] <= Bought[i]
);

constraint sum(i in 1..N) (
    (CurrentPrice[i] - TransactionRate * CurrentPrice[i]) * Sold[i] - 
    max(0, (CurrentPrice[i] - BuyPrice[i]) * Sold[i] * TaxRate / 100.0)
) >= K;

% Objective
var float: ExpectedValue = sum(i in 1..N) ((Bought[i] - Sold[i]) * FuturePrice[i]);
solve maximize ExpectedValue;