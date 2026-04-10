int: num_people;
set of int: PEOPLE = 1..num_people;

array[PEOPLE, PEOPLE] of bool: compatible;

array[PEOPLE, PEOPLE] of var bool: x;

var 0..num_people: num_donations;
var 0..num_people: num_receivers;
var 0..num_people: num_exchanges;

constraint
  forall(i in PEOPLE, j in PEOPLE) (
    x[i,j] -> compatible[i,j]
  );

constraint
  forall(i in PEOPLE) (
    sum(j in PEOPLE)(bool2int(x[i,j])) <= 1
  );

constraint
  forall(j in PEOPLE) (
    sum(i in PEOPLE)(bool2int(x[i,j])) <= 1
  );

constraint
  num_donations = sum(i in PEOPLE, j in PEOPLE)(bool2int(x[i,j]));

constraint
  num_receivers = sum(j in PEOPLE)(min(1, sum(i in PEOPLE)(bool2int(x[i,j]))));

constraint
  num_donations = num_receivers;

constraint
  num_exchanges = num_donations;

solve maximize num_exchanges;

output [
  "num_exchanges=", show(num_exchanges), "\n",
  "num_donations=", show(num_donations), "\n",
  "num_receivers=", show(num_receivers), "\n"
];