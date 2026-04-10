include "globals.mzn";

int: Ncust = 20;
set of int: V = 0..Ncust;
set of int: C = 1..Ncust;

int: K = 5;
set of int: VEH = 1..K;

int: Q = 200;

int: depot_open = 0;
int: depot_close = 1236;

array[V] of int: x = array1d(V, [40, 45,45,42,42,42,40,40,38,38,35,35,25,22,22,20,20,18,15,15,30]);
array[V] of int: y = array1d(V, [50, 68,70,66,68,65,69,66,68,70,66,69,85,75,85,80,85,75,75,80,50]);

array[V] of int: demand = array1d(V, [0, 10,30,10,10,10,20,20,20,10,10,10,20,30,10,40,40,20,20,10,10]);

array[V] of int: tw_open = array1d(V, [
  depot_open,
  912, 825,  65, 727,  15, 621, 170, 255, 534, 357, 448, 652,  30, 567, 384, 475,  99, 179, 278,  10
]);
array[V] of int: tw_close = array1d(V, [
  depot_close,
  967, 870, 146, 782,  67, 702, 225, 324, 605, 410, 505, 721,  92, 620, 429, 528, 148, 254, 345,  73
]);

int: service_time = 90;
array[V] of int: service = array1d(V, [ if i == 0 then 0 else service_time endif | i in V ]);

array[V, V] of int: dist =
  array2d(V, V,
    [ if i == j then 0
      else ceil(sqrt(int2float((x[i]-x[j])*(x[i]-x[j]) + (y[i]-y[j])*(y[i]-y[j]))))
      endif
      | i in V, j in V
    ]);

int: M = depot_close + service_time + max([dist[i,j] | i in V, j in V]);

array[VEH, V, V] of var 0..1: arc;
array[VEH, V] of var 0..depot_close: t;
array[VEH, V] of var 0..1: visit;
array[VEH] of var 0..1: used;

var int: total_distance = sum(k in VEH, i in V, j in V)(dist[i,j] * arc[k,i,j]);

constraint
  forall(k in VEH, i in C)(
    visit[k,i] = sum(j in V where j != i)(arc[k,i,j])
  );

constraint
  forall(k in VEH)(
    used[k] = sum(j in C)(arc[k,0,j])
  );

constraint
  forall(i in C)(
    sum(k in VEH)(visit[k,i]) = 1
  );

constraint
  forall(k in VEH, i in C)(
    sum(j in V where j != i)(arc[k,i,j]) = sum(j in V where j != i)(arc[k,j,i])
  );

constraint
  forall(k in VEH)(
    sum(j in C)(arc[k,0,j]) = used[k] /\
    sum(i in C)(arc[k,i,0]) = used[k]
  );

constraint
  forall(k in VEH, i in V)(arc[k,i,i] = 0);

constraint
  forall(k in VEH)(
    sum(i in C)(demand[i] * visit[k,i]) <= Q
  );

constraint
  forall(k in VEH)(
    t[k,0] >= depot_open /\ t[k,0] <= depot_close
  );

constraint
  forall(k in VEH, i in C)(
    t[k,i] >= tw_open[i] - M*(1-visit[k,i]) /\
    t[k,i] <= tw_close[i] + M*(1-visit[k,i])
  );

constraint
  forall(k in VEH, i in V, j in V where i != j)(
    t[k,j] >= t[k,i] + service[i] + dist[i,j] - M*(1-arc[k,i,j])
  );

constraint
  forall(k in VEH, i in C)(
    t[k,0] >= t[k,i] + service[i] + dist[i,0] - M*(1-arc[k,i,0])
  );

constraint
  forall(k in 1..K-1)(
    used[k] >= used[k+1]
  );

solve minimize total_distance;