int: v;
int: k;
int: lambda;

int: r = lambda * (v - 1) div (k - 1);
int: b = v * r div k;

set of int: OBJECTS = 1..v;
set of int: BLOCKS  = 1..b;

array[OBJECTS, BLOCKS] of var 0..1: x;

constraint
  forall(bl in BLOCKS)(
    sum(o in OBJECTS)(x[o, bl]) = k
  );

constraint
  forall(o in OBJECTS)(
    sum(bl in BLOCKS)(x[o, bl]) = r
  );

constraint
  forall(o1 in OBJECTS, o2 in o1+1..v)(
    sum(bl in BLOCKS)(x[o1, bl] * x[o2, bl]) = lambda
  );

solve satisfy;