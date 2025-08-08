int: CustomerCount;
int: VehicleCount;
array[1..CustomerCount] of int: CustomerDemand;
array[1..CustomerCount] of int: CustomerLBTW;
array[1..CustomerCount] of int: CustomerUBTW;
array[1..CustomerCount, 1..CustomerCount] of int: CustomerDistance;
array[1..CustomerCount] of int: CustomerServiceTime;
array[1..VehicleCount] of int: VehicleCapacity;

int: n = CustomerCount;
int: m = VehicleCount;
set of int: Customers = 1..n;
set of int: AllNodes = 0..n;

array[0..n] of int: CustomerDemandExt = [0] ++ CustomerDemand;
array[0..n] of int: CustomerServiceTimeExt = [0] ++ CustomerServiceTime;
array[0..n] of int: CustomerLBTWExt = [0] ++ CustomerLBTW;
int: maxUB = max(CustomerUBTW);
array[0..n] of int: CustomerUBTWExt = [maxUB] ++ CustomerUBTW;

array[0..n, 0..n] of int: CustomerDistanceExt =
  array2d(0..n, 0..n,
    [if i == 0 \/ j == 0 then 0 else CustomerDistance[i][j] endif
     | i in 0..n, j in 0..n]);

array[AllNodes, AllNodes, 1..m] of var 0..1: x;
array[AllNodes] of var int: t;
array[AllNodes] of var 0..n: u;

% No self loops
constraint forall(i in AllNodes, k in 1..m) x[i,i,k] = 0;

% Each customer visited exactly once
constraint forall(c in Customers) (
  sum(k in 1..m) sum(i in AllNodes) x[i,c,k] = 1 /\
  sum(k in 1..m) sum(j in AllNodes) x[c,j,k] = 1
);

% Each vehicle starts and ends at depot
constraint forall(k in 1..m) (
  sum(j in Customers) x[0,j,k] = 1 /\
  sum(i in Customers) x[i,0,k] = 1
);

% Flow conservation for intermediate nodes
constraint forall(k in 1..m, i in Customers) (
  sum(j in AllNodes) x[i,j,k] = sum(j in AllNodes) x[j,i,k]
);

% MTZ subtour elimination
constraint forall(k in 1..m, i in Customers, j in Customers where i != j) (
  u[i] + 1 <= u[j] + n*(1 - x[i,j,k])
);
constraint u[0] = 0;
constraint forall(i in Customers) u[i] >= 1;

% Time windows
constraint t[0] = 0;
constraint forall(j in Customers) (
  t[j] >= CustomerLBTWExt[j] /\
  t[j] <= CustomerUBTWExt[j]
);

% Time propagation
constraint forall(k in 1..m, i in AllNodes, j in AllNodes where i != j) (
  t[j] >= t[i] + CustomerServiceTimeExt[i] + CustomerDistanceExt[i][j] - maxUB*(1 - x[i,j,k])
);

% Capacity constraints
constraint forall(k in 1..m) (
  sum(c in Customers) CustomerDemandExt[c] * (sum(i in AllNodes) x[i,c,k]) <= VehicleCapacity[k]
);

solve minimize
  sum(k in 1..m, i in AllNodes, j in AllNodes where i != j)
    CustomerDistanceExt[i][j] * x[i,j,k];