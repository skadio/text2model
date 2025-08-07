include "globals.mzn";

/* ------------------------------------------------------------------ */
/* Problem parameters (to be supplied by a .dzn file)                   */
/* ------------------------------------------------------------------ */
int: P;                                 % number of warehouses to open
int: num_customers;
int: num_warehouses;

array[1..num_customers] of float: Demand;
array[1..num_customers, 1..num_warehouses] of float: Distance;

/* ------------------------------------------------------------------ */
/* Decision variables                                                */
/* ------------------------------------------------------------------ */
array[1..num_warehouses] of var 0..1: open;          % 1 = open warehouse
array[1..num_customers, 1..num_warehouses] of var 0..1: assign;

/* ------------------------------------------------------------------ */
/* Constraints                                                       */
/* ------------------------------------------------------------------ */

/* Exactly P warehouses are opened */
constraint count(open, 1, P);

/* Each customer is served by exactly one warehouse */
constraint forall(c in 1..num_customers)(
    sum(w in 1..num_warehouses)(assign[c,w]) = 1
);

/* A customer can only be assigned to an open warehouse */
constraint forall(c in 1..num_customers, w in 1..num_warehouses)(
    assign[c,w] <= open[w]
);

/* ------------------------------------------------------------------ */
/* Objective: minimize demand‑weighted distance                      */
/* ------------------------------------------------------------------ */
var float: total_cost = 
    sum(c in 1..num_customers, w in 1..num_warehouses)(
        Demand[c] * Distance[c,w] * assign[c,w]
    );

solve minimize total_cost;

/* ------------------------------------------------------------------ */
/* Output                                                            */
/* ------------------------------------------------------------------ */
output [
    "Open warehouses: ", show([ w | w in 1..num_warehouses where open[w] = 1 ]), "\n",
    "Customer assignments (warehouse per customer): ", 
    show([ first(w in 1..num_warehouses where assign[c,w] = 1) | c in 1..num_customers ]), "\n",
    "Total cost = ", show(total_cost), "\n"
];