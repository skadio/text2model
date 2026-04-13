include "globals.mzn";

%----------------------------
% Input
%----------------------------
int: num_people;
array[1..num_people, 1..num_people] of bool: compatible; % compatible[donor, recipient]

%----------------------------
% Decision variables
%----------------------------
% succ[i] = the recipient that person i donates to (0 = does not donate)
array[1..num_people] of var 0..num_people: succ;

% pred[i] = the donor that gives to person i (0 = does not receive)
array[1..num_people] of var 0..num_people: pred;

%----------------------------
% Core constraints
%----------------------------

% Link succ and pred as inverses on the active set:
% i donates to j  <->  j receives from i
constraint forall(i in 1..num_people)(
  (succ[i] = 0) <-> (pred[i] = 0)
);

constraint forall(i in 1..num_people)(
  succ[i] = 0 \/ succ[i] != i
);

constraint forall(i in 1..num_people)(
  pred[i] = 0 \/ pred[i] != i
);

constraint forall(i in 1..num_people)(
  succ[i] = 0 \/
  (succ[i] >= 1 /\ succ[i] <= num_people /\ compatible[i, succ[i]])
);

% Functional consistency: each recipient has at most one donor and vice versa.
constraint forall(i in 1..num_people, j in 1..num_people where i != j)(
  (succ[i] = j) <-> (pred[j] = i)
);

% If someone participates, they both donate and receive (already enforced by succ=0 <-> pred=0),
% additionally ensure no two donors donate to the same recipient (injective on active).
constraint forall(j in 1..num_people)(
  sum(i in 1..num_people)(bool2int(succ[i] = j)) <= 1
);

% and no two recipients receive from the same donor (already implied by succ being single-valued),
% but keep symmetry via pred
constraint forall(i in 1..num_people)(
  sum(j in 1..num_people)(bool2int(pred[j] = i)) <= 1
);

%----------------------------
% Objective: maximize number of exchanges (number of participating people)
%----------------------------
var 0..num_people: exchanges = sum(i in 1..num_people)(bool2int(succ[i] != 0));

solve maximize exchanges;

%----------------------------
% Output
%----------------------------
output [
  "exchanges = ", show(exchanges), "\n",
  "succ (donates to) = ", show(succ), "\n",
  "pred (receives from) = ", show(pred), "\n"
];