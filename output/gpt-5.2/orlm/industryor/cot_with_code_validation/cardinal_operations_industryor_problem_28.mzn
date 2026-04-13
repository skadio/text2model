% Jieli Company recruitment goal programming (lexicographic priorities)
% Priorities:
% P1: all demands satisfied
% P2: as many as possible meet preferred specialty (cannot reach 8000 in general)
% P3: as many as possible meet preferred city
% Question asks: at least how many cannot meet P3 under this priority?
%
% We model lexicographic optimization by first maximizing P2, then (among ties)
% maximizing P3.

%%%%%%%%%%%%
% Sets/Data
%%%%%%%%%%%%
int: T = 6;
int: C = 2; % 1=Donghai, 2=Nanjiang
int: S = 3;

set of int: TYPES = 1..T;
set of int: CITIES = 1..C;
set of int: SPECS  = 1..S;

int: total_recruits = 8000;

array[TYPES] of int: supply = [1500,1500,1500,1500,1500,1500];

% demand[city,specialty]
array[CITIES,SPECS] of int: demand =
  [| 1000, 2000, 1500   % Donghai
   | 2000, 1000, 1000   % Nanjiang
  |];

% eligible[type,specialty] = true if type can do specialty
array[TYPES,SPECS] of bool: eligible =
  [| true, true, false   % type 1: 1,2
   | false,true, true    % type 2: 2,3
   | true, false,true    % type 3: 1,3
   | true, false,true    % type 4: 1,3
   | false,true, true    % type 5: 2,3
   | false,false,true    % type 6: 3
  |];

array[TYPES] of int: pref_spec = [1,2,1,3,3,3];
array[TYPES] of int: pref_city = [1,1,2,2,1,2];

%%%%%%%%%%%%%%%%%%%%
% Decision variables
%%%%%%%%%%%%%%%%%%%%
% x[t,c,s] = number of type t assigned to city c, specialty s
array[TYPES,CITIES,SPECS] of var 0..1500: x;

var 0..total_recruits: meet_pref_spec;
var 0..total_recruits: meet_pref_city;

%%%%%%%%%%%%
% Constraints
%%%%%%%%%%%%

% Eligibility: if not eligible then x = 0 (stronger than using multiplication)
constraint
  forall(t in TYPES, c in CITIES, s in SPECS) (
    (not eligible[t,s]) -> (x[t,c,s] = 0)
  );

% Use at most available supply of each type
constraint
  forall(t in TYPES) (
    sum(c in CITIES, s in SPECS)(x[t,c,s]) <= supply[t]
  );

% Total recruited must be 8000
constraint
  sum(t in TYPES, c in CITIES, s in SPECS)(x[t,c,s]) = total_recruits;

% P1: demands must be fully met
constraint
  forall(c in CITIES, s in SPECS) (
    sum(t in TYPES)(x[t,c,s]) = demand[c,s]
  );

% Count preferred specialty matches
constraint
  meet_pref_spec =
    sum(t in TYPES, c in CITIES)( x[t,c,pref_spec[t]] );

% Count preferred city matches
constraint
  meet_pref_city =
    sum(t in TYPES, s in SPECS)( x[t,pref_city[t],s] );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lexicographic optimization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Scale factor so that improving meet_pref_spec by 1 dominates any change in meet_pref_city
int: BIG = total_recruits + 1;

solve maximize BIG * meet_pref_spec + meet_pref_city;

% What the question asks for:
% minimum number who cannot meet P3 under the priority = 8000 - max(meet_pref_city)
output [
  "meet_pref_spec = ", show(meet_pref_spec), "\n",
  "meet_pref_city = ", show(meet_pref_city), "\n",
  "cannot_meet_P3 = ", show(total_recruits - meet_pref_city), "\n"
];