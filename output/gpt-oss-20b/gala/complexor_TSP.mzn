include "globals.mzn";

/*---------------------------*
 *  Input data (from .dzn)    *
 *---------------------------*/
int: OriginNum;
int: DestinationNum;

array[1..OriginNum] of int: Supply;
array[1..DestinationNum] of int: Demand;
array[1..OriginNum, 1..DestinationNum] of int: Cost;

/*---------------------------*
 *  Derived parameters       *
 *---------------------------*/
int: maxSupply = max(Supply);

/*---------------------------*
 *  Decision variables       *
 *---------------------------*/
array[1..OriginNum, 1..DestinationNum] of var 0..maxSupply: x;

/*---------------------------*
 *  Constraints              *
 *---------------------------*/
/* 1. Do not exceed supply at any origin */
constraint
  forall(i in 1..OriginNum) (
    sum(j in 1..DestinationNum) x[i,j] <= Supply[i]
  );

/* 2. Exactly satisfy demand at each destination */
constraint
  forall(j in 1..DestinationNum) (
    sum(i in 1..OriginNum) x[i,j] == Demand[j]
  );

/*---------------------------*
 *  Objective                *
 *---------------------------*/
var int: totalCost = sum(i in 1..OriginNum, j in 1..DestinationNum) Cost[i,j] * x[i,j];

solve minimize totalCost;

/*---------------------------*
 *  Output                    *
 *---------------------------*/
output [
  "Total Cost = ", show(totalCost), "\n",
  "\nTransportation plan (rows = origins, columns = destinations):\n",
  concat([show(x[i]) ++ "\n" | i in 1..OriginNum])
];