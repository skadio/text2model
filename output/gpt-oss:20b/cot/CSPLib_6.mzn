% Parameters
int: m;

% Variables
var int: a[1..m] in 0..m*(m-1)/2;

% Constraints
constraint a[1] = 0;
constraint forall(i in 1..m-1)(a[i] < a[i+1]);
constraint all_different([a[j] - a[i] | i in 1..m-1, j in i+1..m]);
constraint a[2] < a[m] - a[m-1];

% Objective
solve minimize a[m];