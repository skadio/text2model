% Parameters
int: NumPorts;
int: NumTerminals;

set of int: Ports      = 1..NumPorts;
set of int: Terminals  = 1..NumTerminals;

array[Terminals, Ports] of int: Cost;
array[Ports]             of int: Demand;
array[Terminals]         of int: Supply;

int: TotalSupply = sum(k in Terminals)(Supply[k]);

% Variables
array[Terminals, Ports] of var 0..TotalSupply: X;

% Constraints
constraint
    forall(k in Terminals)(
        sum(l in Ports)(X[k,l]) <= Supply[k]
    );

constraint
    forall(l in Ports)(
        sum(k in Terminals)(X[k,l]) == Demand[l]
    );

% Objective
solve minimize
    sum(k in Terminals, l in Ports)(Cost[k,l] * X[k,l]);