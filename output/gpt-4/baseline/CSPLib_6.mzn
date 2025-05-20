include "globals.mzn";

% Number of marks on the Golomb ruler
int: m;

% The marks on the ruler
array[1..m] of var 0..m*m: a;

% The differences between the marks
array[1..m, 1..m] of var 0..m*m: d;

% The objective is to minimize the length of the ruler
var 0..m*m: length;

% The constraints
constraint a[1] = 0;
constraint forall(i in 2..m)(a[i] > a[i-1]);
constraint forall(i in 1..m, j in i+1..m)(d[i,j] = a[j] - a[i]);
constraint forall(i in 1..m, j in i+1..m, k in j+1..m, l in k+1..m)(d[i,j] != d[k,l]);
constraint a[2] - a[1] < a[m] - a[m-1];
constraint length = a[m];

% The objective is to minimize the length of the ruler
solve minimize length;

% Output the solution
output ["Length of the smallest Golomb ruler with ", show(m), " marks: ", show(length), "\n"];
output ["Marks: " ++ show(a)];