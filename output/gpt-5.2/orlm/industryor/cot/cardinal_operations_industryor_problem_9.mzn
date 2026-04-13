% Parameters (with values embedded)
int: N = 12;
set of int: AREAS = 1..N;

% Index mapping:
% 1:A 2:B 3:C 4:D 5:E 6:F 7:G 8:H 9:I 10:J 11:K 12:L

array[AREAS, AREAS] of bool: cover = 
% cover[i,j] = true if a store in area j covers residential area i (within 800m)
[
% j:   A     B     C     D     E     F     G     H     I     J     K     L
/*A*/ [true, false,true, false,true, false,true, true, true, false,false,false],
/*B*/ [false,true, false,false,false,false,false,true, true, false,false,false],
/*C*/ [true, false,true, false,false,false,true, true, true, false,false,false],
/*D*/ [false,false,false,true, false,false,false,false,false,true, false,false],
/*E*/ [true, false,false,false,true, false,true, false,false,false,false,false],
/*F*/ [false,false,false,false,false,true, false,false,false,true, true, false],
/*G*/ [true, false,true, false,true, false,true, false,false,false,false,false],
/*H*/ [true, true, true, false,false,false,false,true, true, false,false,false],
/*I*/ [true, true, true, false,false,false,false,true, true, false,false,false],
/*J*/ [false,false,false,true, false,true, false,false,false,true, true, true ],
/*K*/ [false,false,false,false,false,true, false,false,false,true, true, true ],
/*L*/ [false,false,false,false,false,false,false,false,false,true, true, true ]
];

array[AREAS] of string: area_name = ["A","B","C","D","E","F","G","H","I","J","K","L"];

% Variables
array[AREAS] of var 0..1: build;  % build[j]=1 if a store is built in area j

% Constraints
constraint
  forall(i in AREAS) (
    sum(j in AREAS)( bool2int(cover[i,j]) * build[j] ) >= 1
  );

% Objective
solve minimize sum(j in AREAS)(build[j]);

output [
  "Minimum number of stores = ", show(sum(j in AREAS)(build[j])), "\n",
  "Build in areas: ",
  concat([ if fix(build[j]) = 1 then area_name[j] ++ " " else "" endif | j in AREAS ]),
  "\n"
];