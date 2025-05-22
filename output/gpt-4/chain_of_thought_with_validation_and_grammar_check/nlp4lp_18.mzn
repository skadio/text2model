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
  TaxRate * max(0, (CurrentPrice[i] - BuyPrice[i]) * Sold[i])
) >= K;

% Objective
solve maximize sum(i in 1..N) (
  (Bought[i] - Sold[i]) * FuturePrice[i]
);