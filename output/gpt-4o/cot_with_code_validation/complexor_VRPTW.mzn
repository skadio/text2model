% Parameters
int: CustomerCount;
int: VehicleCount;

set of int: CUSTOMERS = 1..CustomerCount;
set of int: VEHICLES  = 1..VehicleCount;

array[CUSTOMERS]             of int: CustomerDemand;
array[CUSTOMERS]             of int: CustomerLBTW;
array[CUSTOMERS]             of int: CustomerUBTW;
array[CUSTOMERS,CUSTOMERS]   of int: CustomerDistance;
array[CUSTOMERS]             of int: CustomerServiceTime;
array[VEHICLES]              of int: VehicleCapacity;

% A sufficiently large constant for “big-M” constraints
int: BigM = max(CustomerUBTW)
            + max(CustomerServiceTime)
            + max([CustomerDistance[i,j] | i,j in CUSTOMERS]);

% Variables
array[VEHICLES, CUSTOMERS, CUSTOMERS] of var bool: x;     % 1 if vehicle v travels i -> j
array[CUSTOMERS]                      of var int: arrival; % service start time for every customer

% Constraints
constraint
   forall(v in VEHICLES, i in CUSTOMERS)(
      x[v,i,i] = false                   % forbid self‐loops
   );

constraint
   forall(j in CUSTOMERS)(
      sum(v in VEHICLES, i in CUSTOMERS where i != j)(bool2int(x[v,i,j])) = 1  % exactly one predecessor
   ) /\
   forall(i in CUSTOMERS)(
      sum(v in VEHICLES, j in CUSTOMERS where j != i)(bool2int(x[v,i,j])) = 1  % exactly one successor
   );

constraint
   forall(v in VEHICLES, k in CUSTOMERS)(
      sum(i in CUSTOMERS where i != k)(bool2int(x[v,i,k])) =
      sum(j in CUSTOMERS where j != k)(bool2int(x[v,k,j]))                     % flow conservation
   );

constraint
   forall(v in VEHICLES)(
      sum(i in CUSTOMERS, j in CUSTOMERS where i != j)(
         CustomerDemand[i] * bool2int(x[v,i,j])
      ) <= VehicleCapacity[v]                                                  % capacity
   );

constraint
   forall(i in CUSTOMERS)(
      arrival[i] >= CustomerLBTW[i] /\ arrival[i] <= CustomerUBTW[i]           % time windows
   );

constraint
   forall(v in VEHICLES, i in CUSTOMERS, j in CUSTOMERS where i != j)(
      arrival[j] >= arrival[i]
                   + CustomerServiceTime[i]
                   + CustomerDistance[i,j]
                   - BigM * (1 - bool2int(x[v,i,j]))                           % time propagation
   );

% Objective
solve minimize
   sum(v in VEHICLES, i in CUSTOMERS, j in CUSTOMERS)(
      CustomerDistance[i,j] * bool2int(x[v,i,j])
   );