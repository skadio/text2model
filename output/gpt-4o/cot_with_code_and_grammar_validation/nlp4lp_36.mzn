int: C;

array[int] of int: Value;
array[int] of int: Size;

set of int: ITEMS = index_set(Value);

constraint index_set(Size) = ITEMS;

array[ITEMS] of var 0..1: x;

constraint
    sum(i in ITEMS)(Size[i] * x[i]) <= C;

solve maximize sum(i in ITEMS)(Value[i] * x[i]);