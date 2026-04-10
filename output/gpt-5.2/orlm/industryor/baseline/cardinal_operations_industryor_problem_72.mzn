% Li family trip selection - minimize total cost with logical constraints

enum CHILD = {Alice, Bob, Charlie, Diana, Ella};

array[CHILD] of int: cost = [
  1000, % Alice
  900,  % Bob
  600,  % Charlie
  500,  % Diana
  700   % Ella
];

array[CHILD] of var bool: take;

constraint sum(c in CHILD)(bool2int(take[c])) <= 3;  % up to 3 children
constraint sum(c in CHILD)(bool2int(take[c])) >= 2;  % at least 2 children

% Bob is definitely taken
constraint take[Bob];

% Incompatibilities
constraint take[Alice] -> not take[Diana];
constraint take[Bob]   -> not take[Charlie];

% Implications
constraint take[Charlie] -> take[Diana];
constraint take[Diana]   -> take[Ella];

var int: total_cost = sum(c in CHILD)(cost[c] * bool2int(take[c]));

solve minimize total_cost;

output [
  "Total cost: $", show(total_cost), "\n",
  "Taken children: ",
  concat([ if fix(take[c]) then show(c) ++ " " else "" endif | c in CHILD ]),
  "\n",
  "Decision (1=taken, 0=not):\n",
  concat([ show(c) ++ ": " ++ show(bool2int(take[c])) ++ "\n" | c in CHILD ])
];