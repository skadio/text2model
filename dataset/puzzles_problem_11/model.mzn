include "globals.mzn"; 

int: n; % number of different bottle types
array[int] of int: b; % number of bottles for each bottle type
array[int] of int: t; % ration of oil for each bottle type (integers)
int: num_people; % number of people

int: tot_oil = sum([t[i]*b[i] | i in 1..n]); % total amount of oil
int: tot_bottles = sum(b);                   % total number of bottles

% decision variables
% Number of bottles of each type should be distributed to each son
array[1..num_people,1..n] of var 0..tot_oil: allocations;

% satisfaction
solve satisfy;

% Total number of bottles per son 
constraint
  forall(s in 1..num_people) (
    num_people * sum(allocations[s, ..]) = tot_bottles
  );

% Total amount of oil per son
constraint
  forall(s in 1..num_people) (
    num_people * sum([allocations[s, j] * t[j] | j in 1..n]) = tot_oil
  );

% Allocations are in lexicographical order
constraint
  forall(s in 1..num_people-1) (
    lex_lesseq(allocations[s, ..], allocations[s+1, ..])
  );

% Ensure that the exact number of bottles is distributed for each bottle type
constraint
  forall(j in 1..n) (
    sum(allocations[.., j]) = b[j]
  );


% output
output
[ "tot_bottles: \(tot_bottles)\n",
  "tot_oil: \(tot_oil)\n",
] ++
[
        "\(allocations[i,..])\n"
        | i in 1..num_people
];