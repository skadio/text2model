include "globals.mzn";

/*
  Goal programming with priorities:
  p1: Meet all demands exactly (hard constraint).
  p2: Maximize number meeting preferred specialty.
  p3: Subject to p1 & p2 optimum, minimize number not meeting preferred city.
  Question asks: at least how many people can't meet P3 under this priority?
*/

/***********************
 * Data (embedded)
 ***********************/
int: N = 9000;

set of int: CITY = 1..2;          % 1=Donghai, 2=Nanjiang
set of int: SPEC = 1..3;          % specialties 1..3
set of int: SLOT = 1..6;          % 1=D-1,2=D-2,3=D-3,4=N-1,5=N-2,6=N-3

% Demand per slot (Table 4-3): [D1,D2,D3,N1,N2,N3]
array[SLOT] of int: demand = [1000, 2000, 1500, 2000, 1000, 1000];

int: T = 6;                       % applicant types
array[1..T] of int: numType = [1500,1500,1500,1500,1500,1500];

% Each type's preferred specialty (Table 4-4)
array[1..T] of SPEC: prefSpec = [1,2,1,3,3,3];

% Each type's preferred city (Table 4-4): 1=Donghai, 2=Nanjiang
array[1..T] of CITY: prefCity = [1,1,2,2,1,2];

% Suitability matrix: suitable[t,s] = true if type t can do specialty s
array[1..T, SPEC] of bool: suitable =
  array2d(1..T, SPEC, [
    true,  true,  false,   % type 1: 1,2
    false, true,  true,    % type 2: 2,3
    true,  false, true,    % type 3: 1,3
    true,  false, true,    % type 4: 1,3
    false, true,  true,    % type 5: 2,3
    false, false, true     % type 6: 3
  ]);

/***********************
 * Helpers
 ***********************/
function CITY: cityOfSlot(int: sl) = if sl <= 3 then 1 else 2 endif;
function SPEC: specOfSlot(int: sl) = ((sl - 1) mod 3) + 1;

array[SLOT] of CITY: slotCity = [ cityOfSlot(sl) | sl in SLOT ];
array[SLOT] of SPEC: slotSpec = [ specOfSlot(sl) | sl in SLOT ];

% Slots where each specialty occurs (both cities)
array[SPEC] of set of SLOT: slotsOfSpec =
  [ { sl | sl in SLOT where slotSpec[sl] = s } | s in SPEC ];

/***********************
 * Decision variables
 ***********************/
% x[t,sl] = number of type t assigned to slot sl
array[1..T, SLOT] of var 0..1500: x;

/***********************
 * Priority p1: meet demand exactly (hard)
 ***********************/
% Use global_cardinality on a constructed "people assignment" view:
% We do this by creating counts directly with linear constraints (more scalable),
% but we also keep p1 exact demand satisfaction.
constraint forall(sl in SLOT)(
  sum(t in 1..T)( x[t,sl] ) = demand[sl]
);

% Every person of each type must be assigned somewhere
constraint forall(t in 1..T)(
  sum(sl in SLOT)( x[t,sl] ) = numType[t]
);

% Suitability: cannot assign to a specialty the type can't do
constraint forall(t in 1..T, sl in SLOT)(
  (not suitable[t, slotSpec[sl]]) -> (x[t,sl] = 0)
);

/***********************
 * Priority p2: maximize preferred specialty matches
 ***********************/
var 0..N: preferSpecCount =
  sum(t in 1..T)(
    sum(sl in slotsOfSpec[prefSpec[t]])( x[t,sl] )
  );

/***********************
 * Priority p3: minimize city mismatches
 ***********************/
var 0..N: preferCityCount =
  sum(t in 1..T, sl in SLOT where slotCity[sl] = prefCity[t]) ( x[t,sl] );

var 0..N: notMeetP3 = N - preferCityCount;

/***********************
 * Lexicographic objective: maximize p2 then maximize p3 (minimize notMeetP3)
 ***********************/
solve maximize preferSpecCount * (N + 1) + preferCityCount;

/***********************
 * Output
 ***********************/
output [
  "Preferred specialty matches (P2) = ", show(preferSpecCount), " / ", show(N), "\n",
  "Preferred city matches (P3 met)   = ", show(preferCityCount), " / ", show(N), "\n",
  "At least not meeting P3          = ", show(notMeetP3), "\n",
  "\nAssignments x[type,slot] (slot: 1=D1 2=D2 3=D3 4=N1 5=N2 6=N3):\n",
  concat([ "Type " ++ show(t) ++ ": " ++ show([x[t,sl] | sl in SLOT]) ++ "\n" | t in 1..T ])
];