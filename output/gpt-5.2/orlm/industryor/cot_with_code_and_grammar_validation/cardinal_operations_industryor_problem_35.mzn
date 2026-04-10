include "globals.mzn";

int: N_customers = 20;
int: K = 5;

set of int: Customers = 1..N_customers;
set of int: Nodes = 0..N_customers;
set of int: Vehicles = 1..K;

int: Q = 200;
int: service_time = 90;

array[Nodes] of int: x = array1d(Nodes, [40, 45,45,42,42,42,40,40,38,38,35,35,25,22,22,20,20,18,15,15,30]);
array[Nodes] of int: y = array1d(Nodes, [50, 68,70,66,68,65,69,66,68,70,66,69,85,75,85,80,85,75,75,80,50]);

array[Nodes] of int: demand = array1d(Nodes, [0, 10,30,10,10,10,20,20,20,10,10,10,20,30,10,40,40,20,20,10,10]);

array[Nodes] of int: ready = array1d(Nodes, [0,   912,825,65, 727,15, 621,170,255,534,357,448,652,30, 567,384,475,99, 179,278,10]);
array[Nodes] of int: due   = array1d(Nodes, [1236,967,870,146,782,67, 702,225,324,605,410,505,721,92, 620,429,528,148,254,345,73]);

array[Nodes] of int: serv = array1d(Nodes, [ if i = 0 then 0 else service_time endif | i in Nodes ]);

array[Nodes, Nodes] of int: dist =
  array2d(Nodes, Nodes,
    [ round(sqrt(int2float((x[i]-x[j])*(x[i]-x[j]) + (y[i]-y[j])*(y[i]-y[j]))))
    | i in Nodes, j in Nodes
    ]
  );

int: MAXD = max([dist[i,j] | i in Nodes, j in Nodes]);
int: TMAX = due[0];

int: L = N_customers + 2;
set of int: Pos = 1..L;

array[Vehicles, Pos] of var Nodes: route;
array[Vehicles, Pos] of var 0..TMAX: start;
array[Vehicles, Pos] of var 0..Q: load;
array[Vehicles] of var bool: used;

var 0..(K*(L-1)*MAXD): total_distance;

constraint forall(v in Vehicles)(
  route[v,1] = 0 /\ route[v,L] = 0
);

constraint forall(c in Customers)(
  sum(v in Vehicles, p in 2..L-1)(bool2int(route[v,p] = c)) = 1
);

constraint forall(v in Vehicles)(
  forall(p in 2..L-1, q in p+1..L-1)(
    (route[v,p] != 0 /\ route[v,q] != 0) -> (route[v,p] != route[v,q])
  )
);

constraint forall(v in Vehicles, p in 2..L-1)(
  (route[v,p] = 0) -> (route[v,p+1] = 0)
);

constraint forall(v in Vehicles)(
  used[v] <-> exists(p in 2..L-1)(route[v,p] != 0)
);

constraint forall(v in Vehicles, p in Pos)(
  start[v,p] >= ready[route[v,p]] /\
  start[v,p] <= due[route[v,p]]
);

constraint forall(v in Vehicles, p in 1..L-1)(
  start[v,p+1] >= start[v,p] + serv[route[v,p]] + dist[route[v,p], route[v,p+1]]
);

constraint forall(v in Vehicles)(
  load[v,1] = 0
);

constraint forall(v in Vehicles, p in 2..L)(
  load[v,p] = load[v,p-1] + demand[route[v,p]]
);

constraint forall(v in Vehicles, p in Pos)(
  load[v,p] <= Q
);

constraint forall(v in Vehicles)(
  (not used[v]) ->
    ( forall(p in Pos)(route[v,p] = 0)
      /\ forall(p in Pos)(start[v,p] = ready[0])
      /\ forall(p in Pos)(load[v,p] = 0)
    )
);

constraint total_distance =
  sum(v in Vehicles, p in 1..L-1)(
    dist[route[v,p], route[v,p+1]]
  );

solve minimize total_distance;

output [
  "total_distance=", show(total_distance), "\n",
  "route=\n",
  concat([ "v" ++ show(v) ++ ": " ++ show([ route[v,p] | p in Pos ]) ++ "\n" | v in Vehicles ]),
  "start=\n",
  concat([ "v" ++ show(v) ++ ": " ++ show([ start[v,p] | p in Pos ]) ++ "\n" | v in Vehicles ])
];