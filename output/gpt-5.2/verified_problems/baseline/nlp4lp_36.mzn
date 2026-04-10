int: C;
array[int] of int: Value;
array[int] of int: Size;

int: K = length(Value);
set of int: ITEMS = 1..K;

array[ITEMS] of var 0..1: x;

constraint sum(i in ITEMS)(Size[i] * x[i]) <= C;

var int: total_value = sum(i in ITEMS)(Value[i] * x[i]);

solve maximize total_value;

output [
  "total_value=", show(total_value), "\n",
  "total_size=", show(sum(i in ITEMS)(Size[i] * x[i])), "\n",
  "x=", show([x[i] | i in ITEMS]), "\n"
];