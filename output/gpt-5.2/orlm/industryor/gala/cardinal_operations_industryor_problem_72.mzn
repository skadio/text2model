include "globals.mzn";

%----- Data -----
int: n = 5;
set of int: CHILDREN = 1..n;

int: Alice = 1;
int: Bob = 2;
int: Charlie = 3;
int: Diana = 4;
int: Ella = 5;

array[CHILDREN] of int: cost = [1000, 900, 600, 500, 700];

%----- Decision variables -----
array[CHILDREN] of var 0..1: take;   % take[i]=1 iff child i is taken

%----- Constraints -----
% Up to 3 children
constraint sum(i in CHILDREN)(take[i]) <= 3;

% At least 2 children
constraint sum(i in CHILDREN)(take[i]) >= 2;

% Bob is definitely taken
constraint take[Bob] = 1;

% If take Alice then not Diana
constraint take[Alice] + take[Diana] <= 1;

% If take Bob then not Charlie
constraint take[Bob] + take[Charlie] <= 1;

% If take Charlie then must also take Diana
constraint take[Charlie] <= take[Diana];

% If take Diana then must also take Ella
constraint take[Diana] <= take[Ella];

%----- Objective -----
var int: total_cost = sum(i in CHILDREN)(cost[i] * take[i]);
solve minimize total_cost;

%----- Output -----
output [
  "take = ", show(take), "\n",
  "total_cost = ", show(total_cost), "\n",
  "Selected: ",
  if fix(take[Alice]) = 1 then "Alice " else "" endif,
  if fix(take[Bob]) = 1 then "Bob " else "" endif,
  if fix(take[Charlie]) = 1 then "Charlie " else "" endif,
  if fix(take[Diana]) = 1 then "Diana " else "" endif,
  if fix(take[Ella]) = 1 then "Ella " else "" endif,
  "\n"
];