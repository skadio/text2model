% Parameters (with values embedded)
int: T = 6;                 % applicant types
int: C = 2;                 % cities (1=Donghai, 2=Nanjiang)
int: S = 3;                 % specialties (1..3)

set of int: Types = 1..T;
set of int: Cities = 1..C;
set of int: Specs  = 1..S;

array[Types] of int: avail = [1500,1500,1500,1500,1500,1500];

% demand[city, specialty]
array[Cities, Specs] of int: demand =
  array2d(Cities, Specs,
    [
      1000, 2000, 1500,   % Donghai: spec1,2,3
      2000, 1000, 1000    % Nanjiang: spec1,2,3
    ]);

% suitability[type, specialty] = 1 if type can do specialty
array[Types, Specs] of int: suitable =
  array2d(Types, Specs,
    [
      1,1,0,   % type 1: 1,2
      0,1,1,   % type 2: 2,3
      1,0,1,   % type 3: 1,3
      1,0,1,   % type 4: 1,3
      0,1,1,   % type 5: 2,3
      0,0,1    % type 6: 3
    ]);

array[Types] of int: prefSpec = [1,2,1,3,3,3];
array[Types] of int: prefCity = [1,1,2,2,1,2]; % 1=Donghai, 2=Nanjiang

int: TotalPeople = sum(t in Types)(avail[t]); % = 9000
int: P2Target = 8000;
int: P3Target = 8000;

% Variables
% x[t,c,s] = number of type t assigned to city c and specialty s
array[Types, Cities, Specs] of var 0..1500: x;

% Goal deviation variables
array[Cities, Specs] of var 0..2500: d1_minus;
array[Cities, Specs] of var 0..2500: d1_plus;

var 0..TotalPeople: d2_minus;
var 0..TotalPeople: d2_plus;

var 0..TotalPeople: d3_minus;
var 0..TotalPeople: d3_plus;

% Constraints
% Each type is fully assigned (can be assigned across cities/specialties)
constraint
  forall(t in Types)(
    sum(c in Cities, s in Specs)(x[t,c,s]) = avail[t]
  );

% Enforce suitability (if not suitable => must be 0)
constraint
  forall(t in Types, c in Cities, s in Specs)(
    x[t,c,s] <= avail[t] * suitable[t,s]
  );

% Priority p1: meet all specialty demands in each city (goal equality)
constraint
  forall(c in Cities, s in Specs)(
    sum(t in Types)(x[t,c,s]) + d1_minus[c,s] - d1_plus[c,s] = demand[c,s]
  );

% Priority p2: at least 8000 meet preferred specialty (goal)
constraint
  sum(t in Types, c in Cities)(
    x[t,c,prefSpec[t]]
  ) + d2_minus - d2_plus = P2Target;

% Priority p3: at least 8000 meet preferred city (goal)
constraint
  sum(t in Types, s in Specs)(
    x[t,prefCity[t],s]
  ) + d3_minus - d3_plus = P3Target;

% Objective
% Preemptive/lexicographic goal programming via weighted sum with big-M.
% Minimize: (1) total p1 deviations, then (2) d2_minus, then (3) d3_minus.
int: M2 = 1000000;
int: M3 = 1000;

solve minimize
  M2 * ( sum(c in Cities, s in Specs)(d1_minus[c,s] + d1_plus[c,s]) )
+ M3 * d2_minus
+      d3_minus;

output [
  "Min unmet P3 (d3_minus) = ", show(d3_minus), "\n",
  "Met preferred city = ", show(sum(t in Types, s in Specs)(x[t,prefCity[t],s])), "\n",
  "P3 target = ", show(P3Target), "\n"
];