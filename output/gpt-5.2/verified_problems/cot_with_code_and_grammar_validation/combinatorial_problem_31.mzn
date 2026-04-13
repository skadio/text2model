int: num_people;
array[1..num_people, 1..num_people] of int: compatible;

array[1..num_people, 1..num_people] of var 0..1: x;

constraint
  forall(i in 1..num_people, j in 1..num_people) (
    x[i,j] <= compatible[i,j]
  );

constraint
  forall(i in 1..num_people) (
    x[i,i] = 0
  );

constraint
  forall(i in 1..num_people) (
    sum(j in 1..num_people)(x[i,j]) <= 1
  );

constraint
  forall(j in 1..num_people) (
    sum(i in 1..num_people)(x[i,j]) <= 1
  );

constraint
  forall(p in 1..num_people) (
    sum(j in 1..num_people)(x[p,j]) = sum(i in 1..num_people)(x[i,p])
  );

solve maximize sum(i in 1..num_people, j in 1..num_people)(x[i,j]);