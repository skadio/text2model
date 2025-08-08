include "globals.mzn";

int: N;  % Number of different currencies
array[1..N] of float: Start;  % Initial amount of each currency
array[1..N] of float: Limit;  % Limit for the number of transactions for each currency
array[1..N, 1..N] of float: Rate;  % Exchange rates between currencies

% Variables representing the amount of each currency at the end of the day
array[1..N] of var 0..sum(Start) : End;

% Constraints to ensure that the amount of currency does not exceed the limit
constraint forall(i in 1..N)( End[i] <= Start[i] + Limit[i] );

% Constraints to ensure that wealth cannot be multiplied through cycles
% This is a simplified version of the constraints based on the rates
constraint forall(i, j in 1..N where i != j)(
    End[j] >= Rate[i, j] * End[i]
);

% Objective: Maximize the total amount of currency at the end of the day
var float: totalEnd = sum(End);
solve maximize totalEnd;

% Output the results
output [ "End amounts = ", show(End), "\nTotal amount = ", show(totalEnd), "\n" ];