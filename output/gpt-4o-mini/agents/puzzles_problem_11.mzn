include "globals.mzn";

int: n;                          % Number of bottle types
array[1..n] of var int: b;      % Number of bottles of each type
array[1..n] of var int: t;      % Number of bottles with each type of fill amount
int: num_people;                % Number of people

array[1..num_people] of var int: allocation; % Allocations for each person
array[1..num_people] of var int: amounts;    % Amounts allocated

% Constraint to ensure allocations are in lexicographical order
constraint lex_less(allocation, amounts);

% Each person should receive the same number of bottles and the same amount of liquid
constraint forall(i in 1..num_people)(
    allocation[i] = sum(j in 1..n)(b[j]) / num_people
);

% Ensure that the total amount of liquid distributed is equal to the total amount available
constraint sum(i in 1..num_people)(amounts[i]) = sum(j in 1..n)(t[j]);

% Ensure that allocations are increasing
constraint increasing(allocation);

% Solve & output
solve satisfy;
output [ "Allocations = ", show(allocation), "\nAmounts = ", show(amounts), "\n" ];