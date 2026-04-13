% Parameters
% Set of residential areas (candidates for store locations and areas to be covered)
set of int: Areas = 1..12;

% Human-readable names for areas (index aligned with Areas)
array[Areas] of string: area_name = ["A","B","C","D","E","F","G","H","I","J","K","L"];

% cover[i,j] = true if a store in area j covers area i (within 800m)
array[Areas, Areas] of bool: cover =
array2d(Areas, Areas,
[
%   A      B      C      D      E      F      G      H      I      J      K      L   % store location j
    true,  false, true,  false, true,  false, true,  true,  true,  false, false, false, % covered area i = A
    false, true,  false, false, false, false, false, true,  true,  false, false, false, % i = B
    true,  false, true,  false, false, false, true,  true,  true,  false, false, false, % i = C
    false, false, false, true,  false, false, false, false, false, true,  false, false, % i = D
    true,  false, false, false, true,  false, true,  false, false, false, false, false, % i = E
    false, false, false, false, false, true,  false, false, false, true,  true,  false, % i = F
    true,  false, true,  false, true,  false, true,  false, false, false, false, false, % i = G
    true,  true,  true,  false, false, false, false, true,  true,  false, false, false, % i = H
    true,  true,  true,  false, false, false, false, true,  true,  false, false, false, % i = I
    false, false, false, true,  false, true,  false, false, false, true,  true,  true,  % i = J
    false, false, false, false, false, true,  false, false, false, true,  true,  true,  % i = K
    false, false, false, false, false, false, false, false, false, true,  true,  true   % i = L
]);

% Variables
% build[j] = true if a chain store is built in area j
array[Areas] of var bool: build;

% covered[i] = true if residential area i is within 800m of at least one built store
array[Areas] of var bool: covered;

% Constraints
% Link coverage variables to chosen store locations:
% An area i is covered iff there exists at least one built store j that covers i.
constraint
  forall(i in Areas) (
    covered[i] <-> exists(j in Areas) (build[j] /\ cover[i,j])
  );

% Enforce full service requirement: every residential area must be covered.
constraint
  forall(i in Areas) (
    covered[i]
  );

% Objective
solve minimize sum(j in Areas)(bool2int(build[j]));