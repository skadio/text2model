int: C;
int: K;
array[1..K] of int: Value;
array[1..K] of int: Size;

array[1..K] of var 0..1: x;
var int: total_value;
var int: total_size;

constraint forall(k in 1..K)(Value[k] >= 0);
constraint forall(k in 1..K)(Size[k] >= 0);

constraint total_value = sum(k in 1..K)(Value[k] * x[k]);
constraint total_size  = sum(k in 1..K)(Size[k] * x[k]);

constraint total_size <= C;

solve maximize total_value;