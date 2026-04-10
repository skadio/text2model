% Zhang family trip selection - minimize total cost

set of string: CHILDREN = {"Harry","Hermione","Ron","Fred","George","Ginny"};

array[CHILDREN] of int: cost = 
  [ "Harry"   | 1200,
    "Hermione"| 1650,
    "Ron"     |  750,
    "Fred"    |  800,
    "George"  |  800,
    "Ginny"   | 1500 ];

array[CHILDREN] of var bool: take;

var int: total_cost = sum(c in CHILDREN)(cost[c] * bool2int(take[c]));
var int: num_taken  = sum(c in CHILDREN)(bool2int(take[c]));

constraint take["Ginny"];                 % must take Ginny
constraint num_taken <= 4;                % up to four children
constraint num_taken >= 3;                % at least three children

% Compatibility / implication constraints
constraint take["Harry"] -> not take["Fred"];
constraint take["Harry"] -> not take["George"];
constraint take["George"] -> take["Fred"];
constraint take["George"] -> take["Hermione"];

solve minimize total_cost;

output [
  "Total cost: $", show(total_cost), "\n",
  "Children taken (", show(num_taken), "): ",
  concat([ if fix(take[c]) then c ++ " " else "" endif | c in CHILDREN ]),
  "\n",
  "Decision by child:\n",
  concat([ c ++ ": " ++ (if fix(take[c]) then "take" else "not take" endif) ++
          " ($" ++ show(cost[c]) ++ ")\n"
        | c in CHILDREN ])
];