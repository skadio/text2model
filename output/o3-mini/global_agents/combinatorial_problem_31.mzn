include "globals.mzn";

% Data parameters
int: num_people;
array[1..num_people, 1..num_people] of int: compatible; % 1 if donor i can donate to person j, 0 otherwise

% Decision Variables:
% active[i] = 1 if person i participates (donates and receives), and 0 otherwise.
array[1..num_people] of var 0..1: active;

% recipient[i] is the index of the person that receives the kidney from donor i.
% If person i is not active then we force recipient[i] = 0.
array[1..num_people] of var 0..num_people: recipient;

% Constraints:
%
% 1. For each person i:
%    - If not active then they donate to no one (recipient[i] = 0).
%    - If active then:
%         * They must donate to someone (recipient[i] ≠ 0).
%         * They cannot donate to themselves.
%         * The donation must be compatible.
%         * Their chosen recipient must also be active (so that they receive a kidney from someone).
constraint
  forall(i in 1..num_people) (
    (active[i] = 0 -> recipient[i] = 0)
    /\
    (active[i] = 1 -> (recipient[i] != 0 /\ recipient[i] != i /\ compatible[i, recipient[i]] = 1 /\ active[recipient[i]] = 1))
  );

% 2. Every person who participates must receive exactly one kidney.
%    In other words, for every person j, j is active if and only if exactly one person is donating their kidney to j.
constraint
  forall(j in 1..num_people)(
    (active[j] = 1) <-> (sum(i in 1..num_people)(bool2int(recipient[i] = j)) = 1)
  );

% Objective: Maximize the total number of participants in the kidney exchange (i.e. maximize the number of full exchanges)
solve maximize sum(i in 1..num_people)(active[i]);

% Output the participation vector, donation assignment, and total number of exchanges.
output [
  "Active = ", show(active), "\n",
  "Recipient = ", show(recipient), "\n",
  "Total Exchanges = ", show(sum(i in 1..num_people)(active[i])), "\n"
];