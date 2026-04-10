int: num_people;
array[1..num_people, 1..num_people] of int: compatible;

array[1..num_people] of var 1..num_people: give_to;

constraint
  forall(i in 1..num_people) (
    compatible[i, give_to[i]] = 1
  );

constraint
  forall(i in 1..num_people) (
    count(j in 1..num_people)(give_to[j] = i) = 1
  );

solve maximize num_people;