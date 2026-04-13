int: CustomerCount;
int: VehicleCount;

array[1..CustomerCount] of int: CustomerDemand;
array[1..CustomerCount] of int: CustomerLBTW;
array[1..CustomerCount] of int: CustomerUBTW;
array[1..CustomerCount, 1..CustomerCount] of int: CustomerDistance;
array[1..CustomerCount] of int: CustomerServiceTime;

array[1..VehicleCount] of int: VehicleCapacity;

int: Depot = CustomerCount + 1;
set of int: Nodes = 1..Depot;
set of int: Customers = 1..CustomerCount;
set of int: Vehicles = 1..VehicleCount;

int: MaxUB   = max([CustomerUBTW[c] | c in Customers]);
int: MaxDist = max([CustomerDistance[i,j] | i in Customers, j in Customers]);
int: MaxServ = max([CustomerServiceTime[c] | c in Customers]);
int: MaxCap  = max([VehicleCapacity[v] | v in Vehicles]);

int: BigMTime = MaxUB + (CustomerCount + 2) * (MaxDist + MaxServ + 1);
int: BigMLoad = MaxCap + max([CustomerDemand[c] | c in Customers]);

array[Nodes, Nodes] of int: Dist =
  array2d(Nodes, Nodes,
    [ if (i == Depot) \/ (j == Depot) then 0 else CustomerDistance[i,j] endif
    | i in Nodes, j in Nodes ]
  );

array[Nodes] of int: Demand =
  [ if n == Depot then 0 else CustomerDemand[n] endif | n in Nodes ];

array[Nodes] of int: Service =
  [ if n == Depot then 0 else CustomerServiceTime[n] endif | n in Nodes ];

array[Nodes] of int: LBTW =
  [ if n == Depot then 0 else CustomerLBTW[n] endif | n in Nodes ];

array[Nodes] of int: UBTW =
  [ if n == Depot then BigMTime else CustomerUBTW[n] endif | n in Nodes ];

array[Vehicles, Nodes, Nodes] of var 0..1: x;
array[Vehicles, Nodes] of var 0..BigMTime: t;
array[Vehicles, Nodes] of var 0..MaxCap: load;

constraint forall(v in Vehicles, i in Nodes)(x[v,i,i] = 0);

constraint
  forall(c in Customers)(
    sum([x[v,i,c] | v in Vehicles, i in Nodes]) = 1
  );

constraint
  forall(v in Vehicles, c in Customers)(
    sum([x[v,i,c] | i in Nodes]) = sum([x[v,c,j] | j in Nodes])
  );

constraint
  forall(v in Vehicles)(
    sum([x[v,Depot,j] | j in Customers]) = sum([x[v,i,Depot] | i in Customers])
  );

constraint
  forall(v in Vehicles)(
    sum([x[v,Depot,j] | j in Customers]) <= 1
  );

constraint
  forall(v in Vehicles)(
    sum([x[v,i,j] | i in Customers, j in Customers]) <=
      CustomerCount * sum([x[v,Depot,j] | j in Customers])
  );

constraint
  forall(v in Vehicles, n in Nodes)(
    (t[v,n] >= LBTW[n]) /\ (t[v,n] <= UBTW[n])
  );

constraint
  forall(v in Vehicles, i in Nodes, j in Customers where i != j)(
    t[v,j] >= t[v,i] + Service[i] + Dist[i,j] - BigMTime * (1 - x[v,i,j])
  );

constraint
  forall(v in Vehicles, i in Customers)(
    t[v,Depot] >= t[v,i] + Service[i] + Dist[i,Depot] - BigMTime * (1 - x[v,i,Depot])
  );

constraint forall(v in Vehicles)(load[v,Depot] = 0);

constraint
  forall(v in Vehicles, i in Nodes, j in Customers where i != j)(
    load[v,j] >= load[v,i] + Demand[j] - BigMLoad * (1 - x[v,i,j])
  );

constraint
  forall(v in Vehicles, i in Nodes, j in Customers where i != j)(
    load[v,j] <= load[v,i] + Demand[j] + BigMLoad * (1 - x[v,i,j])
  );

constraint forall(v in Vehicles, n in Nodes)(load[v,n] <= VehicleCapacity[v]);

constraint forall(v in Vehicles, c in Customers)(load[v,c] >= Demand[c]);

solve minimize
  sum([Dist[i,j] * x[v,i,j] | v in Vehicles, i in Nodes, j in Nodes]);