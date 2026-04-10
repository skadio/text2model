int: height;
int: width;
int: maxship;

array[1..width, 1..height] of int: hint;
array[1..width] of int: rowsum;
array[1..height] of int: colsum;
array[1..maxship] of int: ship;

set of int: X = 1..width;
set of int: Y = 1..height;
set of int: L = 1..maxship;

array[X, Y] of var 0..1: occ;

array[L] of int: N = [ship[l] | l in L];
int: maxN = max(N);

array[L, 1..maxN] of var 0..1: use;
array[L, 1..maxN] of var 1..width: sx;
array[L, 1..maxN] of var 1..height: sy;
array[L, 1..maxN] of var 0..1: horiz;

constraint
  forall(l in L, k in 1..maxN) (
    use[l,k] = bool2int(k <= N[l])
  );

constraint
  forall(l in L, k in 1..maxN) (
    use[l,k] = 1 ->
      ((horiz[l,k] = 1 -> sx[l,k] + l - 1 <= width) /\
       (horiz[l,k] = 0 -> sy[l,k] + l - 1 <= height))
  );

constraint
  forall(x in X) (
    sum(y in Y)(occ[x,y]) = rowsum[x]
  );

constraint
  forall(y in Y) (
    sum(x in X)(occ[x,y]) = colsum[y]
  );

constraint
  forall(x in X, y in Y) (
    occ[x,y] =
      sum(l in L, k in 1..maxN) (
        use[l,k] * bool2int(
          (horiz[l,k] = 1 /\ y = sy[l,k] /\ x >= sx[l,k] /\ x <= sx[l,k] + l - 1) \/
          (horiz[l,k] = 0 /\ x = sx[l,k] /\ y >= sy[l,k] /\ y <= sy[l,k] + l - 1)
        )
      )
  );

constraint
  forall(x in X, y in Y) (
    sum(l in L, k in 1..maxN) (
      use[l,k] * bool2int(
        (horiz[l,k] = 1 /\ y = sy[l,k] /\ x >= sx[l,k] /\ x <= sx[l,k] + l - 1) \/
        (horiz[l,k] = 0 /\ x = sx[l,k] /\ y >= sy[l,k] /\ y <= sy[l,k] + l - 1)
      )
    ) <= 1
  );

constraint
  forall(x in X, y in Y) (
    occ[x,y] = 1 ->
      forall(dx in -1..1, dy in -1..1 where not (dx = 0 /\ dy = 0) /\ x + dx in X /\ y + dy in Y) (
        occ[x + dx, y + dy] = 0
      )
  );

constraint
  forall(x in X, y in Y) (
    (hint[x,y] = 1 -> occ[x,y] = 0) /\
    (hint[x,y] = 2 -> occ[x,y] = 1)
  );

solve satisfy;