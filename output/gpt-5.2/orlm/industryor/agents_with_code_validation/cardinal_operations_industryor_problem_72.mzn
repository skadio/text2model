% Parameters
enum CHILD = {Alice, Bob, Charlie, Diana, Ella};

% cost of taking each child
array[CHILD] of int: cost =
  [ 1000,   % Alice
     900,   % Bob
     600,   % Charlie
     500,   % Diana
     700    % Ella
  ];

int: max_children = 3;      % can take up to 3 children
int: min_children = 2;      % must take at least 2 children


% Variables
array[CHILD] of var 0..1: take;     % take[c] = 1 iff child c is taken
var 0..sum(cost): total_cost;       % total cost of chosen children


% Constraints

% Total cost definition
constraint
  total_cost = sum(c in CHILD)(cost[c] * take[c]);

% Capacity constraint: can take at most max_children children
constraint
  sum(c in CHILD)(take[c]) <= max_children;

% Minimum participation: must take at least min_children children
constraint
  sum(c in CHILD)(take[c]) >= min_children;

% Mandatory child: Bob must be taken
constraint
  take[Bob] = 1;

% Incompatibility: If Alice is taken, Diana is not taken
constraint
  take[Alice] + take[Diana] <= 1;

% Incompatibility: If Bob is taken, Charlie is not taken
constraint
  take[Bob] + take[Charlie] <= 1;

% Dependency: If Charlie is taken, Diana must also be taken
constraint
  take[Charlie] <= take[Diana];

% Dependency: If Diana is taken, Ella must also be taken
constraint
  take[Diana] <= take[Ella];


% Objective
solve minimize total_cost;