include "globals.mzn";

int: N = 7;
set of int: FAC = 1..N;

array[FAC] of int: supply = [229, 345, 231, 164, 354, 437, 265];
array[FAC] of int: demand = [158, 14, 326, 432, 207, 215, 233];

array[FAC, FAC] of int: cost =
[| 0, 26,  8,  7, 34, 35, 34
 | 41, 0, 27, 31,  3, 33, 36
 | 20, 49, 0, 48, 21, 38, 42
 | 10, 35, 26, 0, 21, 33, 31
 | 21, 30, 24, 25, 0,  5,  8
 | 27, 34, 34, 26, 27, 0, 43
 | 38, 20, 11, 43, 49,  9, 0
 |];

constraint sum(i in FAC)(supply[i]) = sum(i in FAC)(demand[i]);

set of int: SUP = { i | i in FAC where supply[i] > demand[i] };
set of int: DEM = { j | j in FAC where demand[j] > supply[j] };

int: nSUP = card(SUP);
int: nDEM = card(DEM);

array[1..nSUP] of int: SUPL = sort([i | i in SUP]);
array[1..nDEM] of int: DEML = sort([j | j in DEM]);

array[1..nSUP] of int: surplus = [supply[SUPL[k]] - demand[SUPL[k]] | k in 1..nSUP];
array[1..nDEM] of int: deficit = [demand[DEML[k]] - supply[DEML[k]] | k in 1..nDEM];

int: max_ship = max(surplus);

array[1..nSUP, 1..nDEM] of var 0..max_ship: x;

constraint forall(ii in 1..nSUP) (
  sum(jj in 1..nDEM)(x[ii, jj]) = surplus[ii]
);

constraint forall(jj in 1..nDEM) (
  sum(ii in 1..nSUP)(x[ii, jj]) = deficit[jj]
);

var int: total_cost =
  sum(ii in 1..nSUP, jj in 1..nDEM)(
    cost[SUPL[ii], DEML[jj]] * x[ii, jj]
  );

solve minimize total_cost;

output
[
  "total_cost = ", show(total_cost), "\n",
  "Shipments (from -> to : amount)\n"
]
++
[
  if fix(x[ii, jj]) > 0 then
    show(SUPL[ii]) ++ " -> " ++ show(DEML[jj]) ++ " : " ++ show(x[ii, jj]) ++ "\n"
  else
    ""
  endif
  | ii in 1..nSUP, jj in 1..nDEM
];