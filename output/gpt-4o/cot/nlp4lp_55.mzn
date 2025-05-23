% Parameters
int: P;
int: C;

set of int: Plants = 1..P;
set of int: Cities = 1..C;

array[Plants] of int: Supply;
array[Cities] of int: Demand;
array[Plants, Cities] of int: TransmissionCosts;

int: TotalDemand = sum(c in Cities)(Demand[c]);

% Variables
array[Plants, Cities] of var 0..TotalDemand: X;

% Constraints
constraint
    forall(p in Plants)(
        sum(c in Cities)(X[p,c]) <= Supply[p]
    );

constraint
    forall(c in Cities)(
        sum(p in Plants)(X[p,c]) == Demand[c]
    );

% Objective
solve minimize
    sum(p in Plants, c in Cities)(X[p,c] * TransmissionCosts[p,c]);