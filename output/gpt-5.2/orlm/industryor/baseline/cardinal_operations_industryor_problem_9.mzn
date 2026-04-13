% Minimum chain store placement (set cover / dominating set variant)
% Each residential area must be within 800m of at least one chosen store location.
% Data embedded from the table.

include "globals.mzn";

enum AREA = {A,B,C,D,E,F,G,H,I,J,K,L};

array[AREA, AREA] of bool: cover = array2d(AREA, AREA,
[
% from A: A, C, E, G, H, I
  true,  false, true,  false, true,  false, true,  true,  true,  false, false, false,
% from B: B, H, I
  false, true,  false, false, false, false, false, true,  true,  false, false, false,
% from C: A, C, G, H, I
  true,  false, true,  false, false, false, true,  true,  true,  false, false, false,
% from D: D, J
  false, false, false, true,  false, false, false, false, false, true,  false, false,
% from E: A, E, G
  true,  false, false, false, true,  false, true,  false, false, false, false, false,
% from F: F, J, K
  false, false, false, false, false, true,  false, false, false, true,  true,  false,
% from G: A, C, E, G
  true,  false, true,  false, true,  false, true,  false, false, false, false, false,
% from H: A, B, C, H, I
  true,  true,  true,  false, false, false, false, true,  true,  false, false, false,
% from I: A, B, C, H, I
  true,  true,  true,  false, false, false, false, true,  true,  false, false, false,
% from J: D, F, J, K, L
  false, false, false, true,  false, true,  false, false, false, true,  true,  true,
% from K: F, J, K, L
  false, false, false, false, false, true,  false, false, false, true,  true,  true,
% from L: J, K, L
  false, false, false, false, false, false, false, false, false, true,  true,  true
]);

array[AREA] of var bool: build;

% Coverage constraint: every area must be covered by at least one built store.
constraint
  forall(a in AREA) (
    exists(s in AREA) (build[s] /\ cover[a,s])
  );

var int: numStores = sum(a in AREA)(bool2int(build[a]));
solve minimize numStores;

output [
  "Minimum number of stores = ", show(numStores), "\n",
  "Build in areas: ",
  concat([ if fix(build[a]) then show(a) ++ " " else "" endif | a in AREA ]),
  "\n"
];