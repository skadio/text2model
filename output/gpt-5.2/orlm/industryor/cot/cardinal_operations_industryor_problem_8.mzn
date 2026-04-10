% Parameters (with values embedded)
int: n = 4;
set of int: TOYS = 1..n;

int: TRUCK = 1;
int: AIRPLANE = 2;
int: BOAT = 3;
int: TRAIN = 4;

array[TOYS] of int: profit = [5, 10, 8, 7];

int: woodAvail = 890;
array[TOYS] of int: woodReq = [12, 20, 15, 10];

int: steelAvail = 500;
array[TOYS] of int: steelReq = [6, 3, 5, 4];

% Safe upper bounds from resource limits (used to bound decision variables)
array[TOYS] of int: maxByWood = [
  woodAvail div woodReq[TRUCK],
  woodAvail div woodReq[AIRPLANE],
  woodAvail div woodReq[BOAT],
  woodAvail div woodReq[TRAIN]
];
array[TOYS] of int: maxBySteel = [
  steelAvail div steelReq[TRUCK],
  steelAvail div steelReq[AIRPLANE],
  steelAvail div steelReq[BOAT],
  steelAvail div steelReq[TRAIN]
];
array[TOYS] of int: maxProd = [
  min(maxByWood[TRUCK], maxBySteel[TRUCK]),
  min(maxByWood[AIRPLANE], maxBySteel[AIRPLANE]),
  min(maxByWood[BOAT], maxBySteel[BOAT]),
  min(maxByWood[TRAIN], maxBySteel[TRAIN])
];

% Variables
array[TOYS] of var 0..1000: x;          % quantities produced
array[TOYS] of var bool: make;          % whether a type is manufactured

% Constraints
constraint forall(t in TOYS) (x[t] <= maxProd[t]);
constraint forall(t in TOYS) (x[t] > 0 <-> make[t]);

constraint sum(t in TOYS)(woodReq[t] * x[t]) <= woodAvail;
constraint sum(t in TOYS)(steelReq[t] * x[t]) <= steelAvail;

% If Haus Toys manufactures trucks, they will not manufacture trains.
constraint make[TRUCK] -> not make[TRAIN];

% If they manufacture boats, they will also manufacture airplanes.
constraint make[BOAT] -> make[AIRPLANE];

% The number of toy boats manufactured cannot exceed the number of toy trains manufactured.
constraint x[BOAT] <= x[TRAIN];

% Objective
solve maximize sum(t in TOYS)(profit[t] * x[t]);