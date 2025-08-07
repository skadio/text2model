include "globals.mzn";

/* Data parameters (to be provided in a .dzn file) */
int: OriginNum;
int: DestinationNum;
array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

/* Determine an upper bound for transportation quantities.
   This bound is the maximum of any supply or demand value,
   that is enough for each individual route. */
int: maxShipment = max(max(Supply), max(Demand));

/* Decision variables: x[i,j] is the number of goods transported 
   from origin i to destination j */
array[1..OriginNum, 1..DestinationNum] of var 0..maxShipment: x;

/* Constraints */

/* 1. Do not exceed the supply at each origin */
constraint
  forall(i in 1..OriginNum) (
    sum(j in 1..DestinationNum)( x[i,j] ) <= Supply[i]
  );

/* 2. Meet exactly the demand at each destination */
constraint
  forall(j in 1..DestinationNum) (
    sum(i in 1..OriginNum)( x[i,j] ) = Demand[j]
  );

/* Objective: Minimize the total transportation cost */
var int: totalCost = sum(i in 1..OriginNum, j in 1..DestinationNum)( Cost[i,j] * x[i,j] );

solve minimize totalCost;

/* Output the minimal cost and the transportation plan */
output [
  "Total Cost = ", show(totalCost), "\nTransport Plan:\n",
  concat([ show([ x[i,j] | j in 1..DestinationNum ]) ++ "\n" | i in 1..OriginNum ])
];