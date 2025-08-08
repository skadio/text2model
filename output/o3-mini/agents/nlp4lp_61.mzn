include "globals.mzn";

/* PARAMETERS (will be provided in the .dzn file) */
int: T;
array[1..T] of int: Demands;
array[1..T] of int: UnloadCosts;
array[1..T] of int: UnloadCapacity;
int: HoldingCost;
int: MaxContainer;
int: InitContainer;
int: NumCranes;
int: CraneCapacity;
int: CraneCost;

/* Auxiliary: maximum unload capacity (to use in variable domains) */
int: maxUnloadCap = max(UnloadCapacity);

/* DECISION VARIABLES */
/* U[t]: number of containers unloaded in period t */
array[1..T] of var 0..maxUnloadCap: U;
/* I[t]: containers held in yard at end of period t */
array[1..T] of var 0..MaxContainer: I;
/* C[t]: number of cranes rented in period t (each crane has capacity to load CraneCapacity containers) */
array[1..T] of var 0..NumCranes: C;

/* CONSTRAINTS */

/* Unloading capacity constraint */
constraint
  forall(t in 1..T) ( U[t] <= UnloadCapacity[t] );

/* Inventory balance dynamics:
   For period 1: I[1] = InitContainer + U[1] - Demands[1]
   For t >= 2: I[t] = I[t-1] + U[t] - Demands[t] */
constraint
  I[1] = InitContainer + U[1] - Demands[1];

constraint
  forall(t in 2..T) (
    I[t] = I[t-1] + U[t] - Demands[t]
  );

/* The yard storage capacity limit */
constraint
  forall(t in 1..T) ( I[t] <= MaxContainer );

/* At the end of the last period, the yard must be empty */
constraint I[T] = 0;

/* Crane capacity constraint:
   The number of containers loaded onto ships in period t equals the demand and must not exceed 
   the loading capability provided by the cranes rented. */
constraint
  forall(t in 1..T) (
    Demands[t] <= C[t] * CraneCapacity
  );

/* OBJECTIVE: Minimize total cost 
   Total cost = sum_t(UnloadCosts[t]*U[t] + CraneCost * C[t]) + sum_{t=1}^{T-1}(HoldingCost * I[t])
   (Holding cost is charged for containers held from one period to the next) */
var int: TotalCost = 
      sum(t in 1..T)( UnloadCosts[t] * U[t] + CraneCost * C[t] )
    + sum(t in 1..T-1)( HoldingCost * I[t] );

solve minimize TotalCost;

output [
  "TotalCost = ", show(TotalCost), "\n",
  "Unloaded: ", show(U), "\n",
  "Inventory: ", show(I), "\n",
  "Cranes rented: ", show(C), "\n"
];