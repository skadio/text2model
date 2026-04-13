% Minimum set cover / facility location (800m coverage)

% Areas indexed 1..12 corresponding to A..L
set of int: AREAS = 1..12;
array[AREAS] of string: name = ["A","B","C","D","E","F","G","H","I","J","K","L"];

% cover[i,j] = true if a store built in area j covers residential area i (within 800m)
array[AREAS, AREAS] of bool: cover =
  [| true,  false, true,  false, true,  false, true,  true,  true,  false, false, false   % A
   | false, true,  false, false, false, false, false, true,  true,  false, false, false   % B
   | true,  false, true,  false, false, false, true,  true,  true,  false, false, false   % C
   | false, false, false, true,  false, false, false, false, false, true,  false, false   % D
   | true,  false, false, false, true,  false, true,  false, false, false, false, false   % E
   | false, false, false, false, false, true,  false, false, false, true,  true,  false   % F
   | true,  false, true,  false, true,  false, true,  false, false, false, false, false   % G
   | true,  true,  true,  false, false, false, false, true,  true,  false, false, false   % H
   | true,  true,  true,  false, false, false, false, true,  true,  false, false, false   % I
   | false, false, false, true,  false, true,  false, false, false, true,  true,  true    % J
   | false, false, false, false, false, true,  false, false, false, true,  true,  true    % K
   | false, false, false, false, false, false, false, false, false, true,  true,  true    % L
  |];

% Decision variables
array[AREAS] of var bool: build; % build[j] = true if a store is built in area j

% Each area must be covered by at least one built store
constraint
  forall(i in AREAS)(
    exists(j in AREAS)(cover[i,j] /\ build[j])
  );

% Objective: minimize number of stores
solve minimize sum(j in AREAS)(bool2int(build[j]));

output [
  "Minimum stores = ", show(sum(j in AREAS)(bool2int(build[j]))), "\n",
  "Build in areas: ",
  concat([ if fix(build[j]) then name[j] ++ " " else "" endif | j in AREAS ]),
  "\n"
];