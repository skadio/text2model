int: CustomerCount;
int: VehicleCount;

set of int: CUSTOMERS = 1..CustomerCount;
set of int: VEHICLES  = 1..VehicleCount;
set of int: NODES     = 0..CustomerCount;          % depot (0) + customers

array[CUSTOMERS] of int: CustomerDemand;
array[CUSTOMERS] of int: CustomerLBTW;
array[CUSTOMERS] of int: CustomerUBTW;
array[CUSTOMERS,CUSTOMERS] of int: CustomerDistance;
array[CUSTOMERS] of int: CustomerServiceTime;
array[VEHICLES]  of int: VehicleCapacity;

/* ------------------------------------------------------------ */
/* Helper functions                                              */
/* ------------------------------------------------------------ */
function int: travel(int: i, int: j) =
    if i = 0 \/ j = 0 then 0 else CustomerDistance[i,j] endif;

function int: service(int: i) =
    if i = 0 then 0 else CustomerServiceTime[i] endif;

int: max_service   = max(CustomerServiceTime);
int: max_distance  = max([CustomerDistance[i,j] | i in CUSTOMERS, j in CUSTOMERS]);
int: max_ub        = max(CustomerUBTW);
int: BIGM          = max_ub + max_service + max_distance;

/* ------------------------------------------------------------ */
/* Decision variables                                            */
/* ------------------------------------------------------------ */
array[NODES,NODES,VEHICLES] of var 0..1: x;          % arc usage
array[CUSTOMERS] of var 0..max_ub: arrival;          % start‐of‐service times

var int: total_cost;

/* ------------------------------------------------------------ */
/* Constraints                                                   */
/* ------------------------------------------------------------ */

/* 1. Eliminate self-loops */
constraint
    forall(i in NODES, v in VEHICLES)( x[i,i,v] = 0 );

/* 2. Each customer is entered exactly once */
constraint
    forall(c in CUSTOMERS)(
        sum(v in VEHICLES, i in NODES where i <> c)( x[i,c,v] ) = 1
    );

/* 3. Each customer is left exactly once */
constraint
    forall(c in CUSTOMERS)(
        sum(v in VEHICLES, j in NODES where j <> c)( x[c,j,v] ) = 1
    );

/* 4. Depot flow: every vehicle leaves and returns exactly once */
constraint
    forall(v in VEHICLES)(
        sum(j in CUSTOMERS)( x[0,j,v] ) = 1 /\
        sum(i in CUSTOMERS)( x[i,0,v] ) = 1
    );

/* 5. Flow conservation for every vehicle */
constraint
    forall(v in VEHICLES, c in CUSTOMERS)(
        sum(i in NODES where i <> c)( x[i,c,v] ) =
        sum(j in NODES where j <> c)( x[c,j,v] )
    );

/* 6. Vehicle capacity */
constraint
    forall(v in VEHICLES)(
        sum(c in CUSTOMERS)(
            CustomerDemand[c] *
            sum(i in NODES where i <> c)( x[i,c,v] )
        ) <= VehicleCapacity[v]
    );

/* 7. Time-window compliance */
constraint
    forall(c in CUSTOMERS)(
        CustomerLBTW[c] <= arrival[c] /\ arrival[c] <= CustomerUBTW[c]
    );

/* 8. Time continuity (Big-M) */
constraint
    forall(v in VEHICLES, i in NODES, j in CUSTOMERS where i <> j)(
        arrival[j] >=
            ( (if i = 0 then 0 else arrival[i] endif)
              + service(i) + travel(i,j)
              - BIGM * (1 - x[i,j,v]) )
    );

/* 9. Total cost */
constraint
    total_cost = sum(v in VEHICLES, i in NODES, j in NODES where i <> j)(
                     travel(i,j) * x[i,j,v]
                 );

/* ------------------------------------------------------------ */
/* Objective                                                     */
/* ------------------------------------------------------------ */
solve minimize total_cost;