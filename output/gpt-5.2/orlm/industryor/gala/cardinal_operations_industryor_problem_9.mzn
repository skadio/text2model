include "globals.mzn";

% Minimum dominating set / set cover on residential areas
% Build stores only in the listed areas; every area must be within 800m of a store.

set of int: Areas = 1..12;
array[Areas] of string: Name = ["A","B","C","D","E","F","G","H","I","J","K","L"];

% cover[a,b] = true if a store in area b covers area a (within 800m, including itself)
array[Areas, Areas] of bool: cover =
[
%        A     B     C     D     E     F     G     H     I     J     K     L
/*A*/ [ true, false, true, false, true, false, true, true,  true,  false, false, false ],
/*B*/ [ false,true,  false,false,false,false,false,true,  true,  false, false, false ],
/*C*/ [ true, false, true, false, false,false,true, true,  true,  false, false, false ],
/*D*/ [ false,false,false,true,  false,false,false,false,false,true,  false, false ],
/*E*/ [ true, false, false,false,true, false,true, false, false, false, false, false ],
/*F*/ [ false,false,false,false,false,true, false,false,false,true,  true,  false ],
/*G*/ [ true, false, true, false,true, false,true, false, false, false, false, false ],
/*H*/ [ true, true,  true, false,false,false,false,true,  true,  false, false, false ],
/*I*/ [ true, true,  true, false,false,false,false,true,  true,  false, false, false ],
/*J*/ [ false,false,false,true,  false,true, false,false,false,true,  true,  true  ],
/*K*/ [ false,false,false,false,false,true, false,false,false,true,  true,  true  ],
/*L*/ [ false,false,false,false,false,false,false,false,false,true,  true,  true  ]
];

array[Areas] of var bool: build;  % build[b]=true if a store is built in area b

% Every area must be covered by at least one built store
constraint
  forall(a in Areas)(
    exists(b in Areas)( cover[a,b] /\ build[b] )
  );

% Objective: minimize number of stores
var 0..card(Areas): numStores = sum(b in Areas)(bool2int(build[b]));
solve minimize numStores;

output [
  "Minimum number of stores = ", show(numStores), "\n",
  "Build in areas: ",
  concat([ if fix(build[i]) then Name[i] ++ " " else "" endif | i in Areas ]),
  "\n",
  "Build vector (A..L) = ", show([build[i] | i in Areas]), "\n"
];