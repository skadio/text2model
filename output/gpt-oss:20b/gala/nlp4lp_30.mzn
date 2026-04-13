include "globals.mzn";

/*--- Problem parameters (provided by the .dzn file) ---*/
int: K;                          % number of departments
int: L;                          % number of possible locations (including London)

array[1..K, 1..L] of int: Benefit;          % benefit (thousand £) of dept k in location l
array[1..K, 1..K] of float: Communication;  % communication quantity between dept k and j
array[1..L, 1..L] of float: Cost;           % unit communication cost between location l and m

/*--- Decision variables ---*/
array[1..K] of var 1..L: loc;                % location chosen for each department

/*--- Cardinality constraints: at most 3 departments per location ---*/
array[1..L] of var 0..K: occ;               % number of departments in each location
array[1..L] of int: vals = [1..L];          % set of possible location values

constraint global_cardinality(loc, vals, occ);
constraint forall(l in 1..L)( occ[l] <= 3 );

/*--- Objective: minimize total yearly cost ---*/
/*  Total communication cost  */
var float: total_comm =
   sum(k in 1..K, j in k+1..K) Communication[k,j] * Cost[loc[k], loc[j]];

/*  Total benefit (converted to float)  */
var float: total_benefit =
   sum(k in 1..K) int2float( Benefit[k, loc[k]] );

/*  Net yearly cost (cost minus benefit)  */
var float: total_cost = total_comm - total_benefit;

solve minimize total_cost;

/*--- Output ---*/
output [
    "Department locations: ", show(loc), "\n",
    "Total communication cost: ", show(total_comm), "\n",
    "Total benefit: ", show(total_benefit), "\n",
    "Net yearly cost: ", show(total_cost), "\n",
    "Departments per location: ", show(occ), "\n"
];