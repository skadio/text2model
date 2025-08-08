% Parameters
int: N;
array[1..N] of int: Bought;
array[1..N] of int: BuyPrice;
array[1..N] of int: CurrentPrice;
array[1..N] of int: FuturePrice;
float: TransactionRate;
float: TaxRate;
int: K;

% Variables
var float: x[1..N] in 0..Bought[i];

% Constraints
constraint
    sum(i in 1..N) x[i] * (CurrentPrice[i] * (1 - TransactionRate/100) - (CurrentPrice[i] - BuyPrice[i]) * TaxRate/100) >= K;

% Objective
var float: expected_future_value = sum(i in 1..N) (Bought[i] - x[i]) * FuturePrice[i];
solve maximize expected_future_value;