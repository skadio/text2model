int: m;
int: numDiff = m * (m - 1) div 2;
int: UB = m * m;

array[1..numDiff] of int: iIdx = [ i | i in 1..m-1, j in i+1..m ];
array[1..numDiff] of int: jIdx = [ j | i in 1..m-1, j in i+1..m ];

array[1..m]       of var 0..UB: a;
array[1..numDiff] of var 1..UB: d;
var 0..UB: L;

constraint a[1] = 0;
constraint forall(i in 1..m-1)(a[i] < a[i+1]);
constraint forall(i in 1..m)(a[i] >= i - 1);

constraint forall(k in 1..numDiff)(
    d[k] = a[jIdx[k]] - a[iIdx[k]]
);

constraint all_different(d);

constraint a[2] - a[1] < a[m] - a[m-1];

constraint L = a[m];

solve minimize L;