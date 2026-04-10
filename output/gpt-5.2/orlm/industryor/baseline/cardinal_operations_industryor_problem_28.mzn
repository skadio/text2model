% Goal Programming model (preemptive priorities) for personnel assignment
% Data embedded as per problem statement.

int: T = 6;                 % applicant types
int: C = 2;                 % cities: 1=Donghai, 2=Nanjiang
int: S = 3;                 % specialties 1..3

set of int: Types = 1..T;
set of int: Cities = 1..C;
set of int: Specs  = 1..S;

% Supplies (number of people available per type)
array[Types] of int: supply = [1500,1500,1500,1500,1500,1500];
int: total_people = sum(t in Types)(supply[t]); % = 9000

% City indices
int: Donghai = 1;
int: Nanjiang = 2;

% Preferred city per type
array[Types] of int: pref_city = [Donghai, Donghai, Nanjiang, Nanjiang, Donghai, Nanjiang];

% Preferred specialty per type
array[Types] of int: pref_spec = [1,2,1,3,3,3];

% Suitability matrix: can_do[t,s] = true iff type t can do specialty s
array[Types, Specs] of bool: can_do =
array2d(Types, Specs,
[
  true,  true,  false,   % type 1: 1,2
  false, true,  true,    % type 2: 2,3
  true,  false, true,    % type 3: 1,3
  true,  false, true,    % type 4: 1,3
  false, true,  true,    % type 5: 2,3
  false, false, true     % type 6: 3
]);

% Demand per (city,specialty)
array[Cities, Specs] of int: demand =
array2d(Cities, Specs,
[
  1000, 2000, 1500,   % Donghai: spec1..3
  2000, 1000, 1000    % Nanjiang: spec1..3
]);

% Decision variables: x[t,c,s] = number of type t assigned to city c, specialty s
array[Types, Cities, Specs] of var 0..1500: x;

% Enforce suitability (if not suitable, assignment must be 0)
constraint
  forall(t in Types, c in Cities, s in Specs)(
    (not can_do[t,s]) -> (x[t,c,s] = 0)
  );

% Supply constraints: each type cannot exceed its available people
constraint
  forall(t in Types)(
    sum(c in Cities, s in Specs)(x[t,c,s]) <= supply[t]
  );

% P1: all demands must be fully met (hard, highest priority)
constraint
  forall(c in Cities, s in Specs)(
    sum(t in Types)(x[t,c,s]) = demand[c,s]
  );

% Measures for P2 and P3
var 0..total_people: meet_pref_spec =
  sum(t in Types, c in Cities, s in Specs where s = pref_spec[t])(x[t,c,s]);

var 0..total_people: meet_pref_city =
  sum(t in Types, c in Cities, s in Specs where c = pref_city[t])(x[t,c,s]);

% Targets for P2 and P3
int: target_pref_spec = 8000;
int: target_pref_city = 8000;

% Deviations (only underachievement is penalized)
var 0..total_people: d2_minus = max(0, target_pref_spec - meet_pref_spec);
var 0..total_people: d3_minus = max(0, target_pref_city - meet_pref_city);

% Preemptive optimization: minimize d2_minus first, then d3_minus
solve
  lexicographic_minimize([d2_minus, d3_minus]);

% Quantity asked: minimum number of people that can't meet P3 (preferred city)
% under priorities (P1 then P2 then P3). That is d3_minus at optimum.
output [
  "Meet preferred specialty: ", show(meet_pref_spec), "\n",
  "P2 shortfall (>=0): ", show(d2_minus), "\n",
  "Meet preferred city: ", show(meet_pref_city), "\n",
  "At least number of people that can't meet P3 (preferred city shortfall): ", show(d3_minus), "\n"
];