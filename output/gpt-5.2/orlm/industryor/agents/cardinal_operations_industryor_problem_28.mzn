% Parameters
int: nCities = 2;                      % 1=Donghai, 2=Nanjiang
set of int: CITIES = 1..nCities;

int: nSpecs = 3;                       % specialties 1..3
set of int: SPECS = 1..nSpecs;

int: nTypes = 6;                       % applicant types 1..6
set of int: TYPES = 1..nTypes;

int: totalRecruit = 8000;              % total people to be arranged

array[CITIES, SPECS] of int: demand =  % Table 4-3
  array2d(CITIES, SPECS,
    [ 1000, 2000, 1500,               % Donghai (city 1): spec 1,2,3
      2000, 1000, 1000 ]              % Nanjiang (city 2): spec 1,2,3
  );

array[TYPES] of int: typeCount =       % Table 4-4: number of people in each type
  [1500, 1500, 1500, 1500, 1500, 1500];

array[TYPES, SPECS] of bool: canDo =   % Table 4-4: suitable specialties
  array2d(TYPES, SPECS,
    [ true,  true,  false,            % type 1: 1,2
      false, true,  true,             % type 2: 2,3
      true,  false, true,             % type 3: 1,3
      true,  false, true,             % type 4: 1,3
      false, true,  true,             % type 5: 2,3
      false, false, true ]            % type 6: 3
  );

array[TYPES] of int: prefSpec =        % Table 4-4: preferred specialty
  [1, 2, 1, 3, 3, 3];

array[TYPES] of int: prefCity =        % Table 4-4: preferred city (1=Donghai, 2=Nanjiang)
  [1, 1, 2, 2, 1, 2];


% Variables
array[TYPES, CITIES, SPECS] of var int: x;      % number of type t assigned to city c and specialty s

% Goal deviation-related variables (goal programming)
array[CITIES, SPECS] of var int: underDemand;   % unmet demand (P1 shortfall)
array[CITIES, SPECS] of var int: overDemand;    % oversupply (allowed but penalized implicitly via P1)

var int: notPrefSpec;                           % number not meeting preferred specialty (P2 deviation)
var int: notPrefCity;                           % number not meeting preferred city (P3 deviation)


% Constraints
%-----------------------------
% Domain / nonnegativity
%-----------------------------
constraint
  forall(t in TYPES, c in CITIES, s in SPECS) (
    x[t,c,s] >= 0
  );

constraint
  forall(c in CITIES, s in SPECS) (
    underDemand[c,s] >= 0 /\ overDemand[c,s] >= 0
  );

constraint notPrefSpec >= 0;
constraint notPrefCity >= 0;

%-----------------------------
% Feasibility: assignments only to suitable specialties
%-----------------------------
constraint
  forall(t in TYPES, c in CITIES, s in SPECS) (
    (not canDo[t,s]) -> (x[t,c,s] = 0)
  );

%-----------------------------
% Each applicant type allocated at most its available count
% (Total recruit is 8000, so 1000 may remain unassigned.)
%-----------------------------
constraint
  forall(t in TYPES) (
    sum(c in CITIES, s in SPECS)(x[t,c,s]) <= typeCount[t]
  );

%-----------------------------
% Total recruited/assigned equals required totalRecruit (8000)
%-----------------------------
constraint
  sum(t in TYPES, c in CITIES, s in SPECS)(x[t,c,s]) = totalRecruit;

%-----------------------------
% Demand balance with deviation variables (Goal P1)
%   assigned + under - over = demand
%-----------------------------
constraint
  forall(c in CITIES, s in SPECS) (
    sum(t in TYPES)(x[t,c,s]) + underDemand[c,s] - overDemand[c,s] = demand[c,s]
  );

%-----------------------------
% Preferred specialty deviation (Goal P2)
%   Count people assigned to a non-preferred specialty (regardless of city)
%-----------------------------
constraint
  notPrefSpec =
    sum(t in TYPES, c in CITIES, s in SPECS where s != prefSpec[t]) (x[t,c,s]);

%-----------------------------
% Preferred city deviation (Goal P3)
%   Count people assigned to a non-preferred city (regardless of specialty)
%-----------------------------
constraint
  notPrefCity =
    sum(t in TYPES, c in CITIES where c != prefCity[t], s in SPECS) (x[t,c,s]);


% Objective
% Lexicographic goal programming via big weights:
%   P1: minimize total unmet demand (underDemand) with highest priority,
%   P2: then minimize notPrefSpec,
%   P3: then minimize notPrefCity (question asks this minimum under the priority structure).
solve minimize
    sum(c in CITIES, s in SPECS)(underDemand[c,s]) * 100000000
  + notPrefSpec * 10000
  + notPrefCity;