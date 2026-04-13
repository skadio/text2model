int: num_people;
array[1..num_people, 1..num_people] of bool: compatible;

array[1..num_people] of var 0..num_people: donate_to;

constraint
  forall(i in 1..num_people) (
    donate_to[i] = 0 \/ compatible[i, donate_to[i]]
  );

constraint
  forall(i in 1..num_people) (
    donate_to[i] != i
  );

constraint
  forall(i in 1..num_people) (
    (donate_to[i] = 0) <-> (sum(j in 1..num_people)(bool2int(donate_to[j] = i)) = 0)
  );

constraint
  forall(i in 1..num_people) (
    donate_to[i] != 0 ->
      sum(j in 1..num_people)(bool2int(donate_to[j] = i)) = 1
  );

constraint
  forall(i in 1..num_people) (
    donate_to[i] = 0 \/
    sum(j in 1..num_people)(bool2int(donate_to[j] = i)) <= 1
  );

var int: num_exchanges = sum(i in 1..num_people)(bool2int(donate_to[i] != 0));

solve maximize num_exchanges;

output [
  "num_exchanges=", show(num_exchanges), "\n",
  "donate_to=", show(donate_to), "\n"
];