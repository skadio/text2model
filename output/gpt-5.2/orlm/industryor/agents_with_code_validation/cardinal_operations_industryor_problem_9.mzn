% Convenience supermarket chain store location (set cover) problem
% Data embedded directly from the problem statement.

int: N = 12;
set of int: AREAS = 1..N;

array[AREAS] of string: area_code = ["A","B","C","D","E","F","G","H","I","J","K","L"];

% cover[i,j] = true iff a store built in area i covers residential area j (within 800m)
array[AREAS, AREAS] of bool: cover = array2d(AREAS, AREAS, [
  % Row A
  true,  false, true,  false, true,  false, true,  true,  true,  false, false, false,
  % Row B
  false, true,  false, false, false, false, false, true,  true,  false, false, false,
  % Row C
  true,  false, true,  false, false, false, true,  true,  true,  false, false, false,
  % Row D
  false, false, false, true,  false, false, false, false, false, true,  false, false,
  % Row E
  true,  false, false, false, true,  false, true,  false, false, false, false, false,
  % Row F
  false, false, false, false, false, true,  false, false, false, true,  true,  false,
  % Row G
  true,  false, true,  false, true,  false, true,  false, false, false, false, false,
  % Row H
  true,  true,  true,  false, false, false, false, true,  true,  false, false, false,
  % Row I
  true,  true,  true,  false, false, false, false, true,  true,  false, false, false,
  % Row J
  false, false, false, true,  false, true,  false, false, false, true,  true,  true,
  % Row K
  false, false, false, false, false, true,  false, false, false, true,  true,  true,
  % Row L
  false, false, false, false, false, false, false, false, false, true,  true,  true
]);

% Decision variables: build[i] = 1 iff a store is built in area i
array[AREAS] of var 0..1: build;

var 0..N: num_stores = sum(i in AREAS)(build[i]);

% Every residential area must be covered by at least one built store
constraint
  forall(j in AREAS)(
    sum(i in AREAS where cover[i,j]) (build[i]) >= 1
  );

solve minimize num_stores;

output [
  "Minimum number of stores = ", show(num_stores), "\n",
  "Build in areas: ",
  concat([ if fix(build[i]) = 1 then area_code[i] ++ " " else "" endif | i in AREAS ]),
  "\n"
];