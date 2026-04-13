% Jieli Company goal programming model (lexicographic priorities p1, p2, p3)
% Cities: 1 = Donghai, 2 = Nanjiang
% Specialties: 1..3
% Types: 1..6

include "globals.mzn";

%-------------------------------
% Sets / Parameters (embedded data)
%-------------------------------
int: nCities = 2;
set of int: CITIES = 1..nCities;

int: nSpecs = 3;
set of int: SPECS = 1..nSpecs;

int: nTypes = 6;
set of int: TYPES = 1..nTypes;

array[CITIES, SPECS] of int: demand =
  array2d(CITIES, SPECS,
    [ 1000, 2000, 1500,   % Donghai
      2000, 1000, 1000 ]  % Nanjiang
  );

array[TYPES] of int: supply = [1500,1500,1500,1500,1500,1500];

array[TYPES, SPECS] of bool: suitable =
  array2d(TYPES, SPECS,
    [ true,  true,  false,   % type 1: 1,2
      false, true,  true,    % type 2: 2,3
      true,  false, true,    % type 3: 1,3
      true,  false, true,    % type 4: 1,3
      false, true,  true,    % type 5: 2,3
      false, false, true ]   % type 6: 3
  );

array[TYPES] of int: prefSpec = [1,2,1,3,3,3];
array[TYPES] of int: prefCity = [1,1,2,2,1,2];

int: targetPrefSpec = 8000;
int: targetPrefCity = 8000;

%-------------------------------
% Decision variables
%-------------------------------
% x[t,c,s] = number of type t assigned to city c and specialty s
array[TYPES, CITIES, SPECS] of var 0..1500: x;

% Deviations for p1 demand goals
array[CITIES, SPECS] of var 0..8000: underDemand;
array[CITIES, SPECS] of var 0..8000: overDemand;

% Deviations for p2 preferred specialty goal
var 0..9000: meetPrefSpec;
var 0..9000: underPrefSpec;
var 0..9000: overPrefSpec;

% Deviations for p3 preferred city goal
var 0..9000: meetPrefCity;
var 0..9000: underPrefCity;
var 0..9000: overPrefCity;

% Reporting: number not meeting preferred city
var 0..9000: notMeetPrefCity;

%-------------------------------
% Constraints
%-------------------------------

% Suitability: forbid assignments to unsuitable specialties
constraint
  forall(t in TYPES, c in CITIES, s in SPECS where not suitable[t,s]) (
    x[t,c,s] = 0
  );

% Supply limits per type
constraint
  forall(t in TYPES) (
    sum(c in CITIES, s in SPECS)(x[t,c,s]) <= supply[t]
  );

% p1: demand goal equations (assigned + under - over = demand)
constraint
  forall(c in CITIES, s in SPECS) (
    sum(t in TYPES)(x[t,c,s]) + underDemand[c,s] - overDemand[c,s] = demand[c,s]
  );

% p2: count meeting preferred specialty
constraint
  meetPrefSpec = sum(t in TYPES, c in CITIES)( x[t,c,prefSpec[t]] );

% p2: goal equation
constraint
  meetPrefSpec + underPrefSpec - overPrefSpec = targetPrefSpec;

% p3: count meeting preferred city
constraint
  meetPrefCity = sum(t in TYPES, s in SPECS)( x[t,prefCity[t],s] );

% p3: goal equation
constraint
  meetPrefCity + underPrefCity - overPrefCity = targetPrefCity;

% Reporting: not meeting preferred city among assigned people
constraint
  notMeetPrefCity = sum(t in TYPES, c in CITIES, s in SPECS)(x[t,c,s]) - meetPrefCity;

%-------------------------------
% Objective: lexicographic (p1, then p2, then p3)
% Note: MiniZinc has no 'lexicographic_minimize' keyword.
% We implement lexicographic minimization via a single weighted objective
% with weights large enough to enforce priority order.
%-------------------------------

int: W1 = 100000000;  % p1 dominates
int: W2 = 10000;      % p2 dominates p3
int: W3 = 1;

var int: obj =
  W1 * sum(c in CITIES, s in SPECS)(underDemand[c,s] + overDemand[c,s])
+ W2 * (underPrefSpec + overPrefSpec)
+ W3 * (underPrefCity + overPrefCity);

solve minimize obj;

%-------------------------------
% Output
%-------------------------------
output [
  "Objective = ", show(obj), "\n",
  "p1 total deviation = ",
    show(sum(c in CITIES, s in SPECS)(underDemand[c,s] + overDemand[c,s])), "\n",
  "p2 under/over = ", show(underPrefSpec), " / ", show(overPrefSpec),
    " (meetPrefSpec=", show(meetPrefSpec), ")\n",
  "p3 under/over = ", show(underPrefCity), " / ", show(overPrefCity),
    " (meetPrefCity=", show(meetPrefCity), ")\n",
  "At least not meeting preferred city (P3) = ", show(notMeetPrefCity), "\n"
];