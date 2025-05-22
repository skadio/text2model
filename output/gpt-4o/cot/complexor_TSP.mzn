% Parameters
int: OriginNum;
int: DestinationNum;

set of int: Origins = 1..OriginNum;
set of int: Destinations = 1..DestinationNum;

array[Origins] of int: Supply;
array[Destinations] of int: Demand;
array[Origins, Destinations] of int: Cost;

% Pre-computed bound for decision variables
int: MaxTransport = sum(d in Destinations)(Demand[d]);

% Variables
array[Origins, Destinations] of var 0..MaxTransport: x;

% Constraints
constraint
  forall(i in Origins)(
    sum(j in Destinations)(x[i,j]) <= Supply[i]
  );

constraint
  forall(j in Destinations)(
    sum(i in Origins)(x[i,j]) == Demand[j]
  );

constraint
  forall(i in Origins, j in Destinations)(
    x[i,j] <= min(Supply[i], Demand[j])
  );

% Objective
solve minimize sum(i in Origins, j in Destinations)(Cost[i,j] * x[i,j]);