% Parameters (with values embedded)
int: N = 4;
set of int: PARTS = 1..N;

array[PARTS] of int: dist_km = [450, 480, 540, 600];

int: maxHeavy = 28;
int: maxLight = 12;
int: fuelLimit = 10000;

% Per-bomb destruction probabilities (given)
array[PARTS] of float: pHeavy = [0.03, 0.10, 0.05, 0.05];
array[PARTS] of float: pLight = [0.08, 0.11, 0.12, 0.09];

% Fuel model:
% - Outbound with bomb:
%     heavy: 2 km per liter  -> liters = dist/2
%     light: 3 km per liter  -> liters = dist/3
% - Return empty: 4 km per liter -> liters = dist/4
% - Takeoff+landing: 100 liters per trip
% So fuel per trip to part i:
%   heavy: 100 + dist/2 + dist/4 = 100 + 3*dist/4
%   light: 100 + dist/3 + dist/4 = 100 + 7*dist/12
array[PARTS] of int: fuelHeavy = [ 100 + (3*dist_km[i]) div 4 | i in PARTS ];
array[PARTS] of int: fuelLight = [ 100 + (7*dist_km[i]) div 12 | i in PARTS ];

% Discretization of probabilities to allow MILP optimization
% (scale chosen large for precision in log space)
int: SCALE = 1000000;

% Log-failure per bomb (negative), precomputed as integer: round(SCALE * ln(1-p))
% ln(1-0.03)=-0.0304592075 -> -30459
% ln(1-0.10)=-0.1053605157 -> -105361
% ln(1-0.05)=-0.0512932944 -> -51293
% ln(1-0.08)=-0.0833816089 -> -83382
% ln(1-0.11)=-0.1165338163 -> -116534
% ln(1-0.12)=-0.1278333715 -> -127833
% ln(1-0.09)=-0.0943106795 -> -94311
array[PARTS] of int: logFailHeavy = [-30459, -105361, -51293, -51293];
array[PARTS] of int: logFailLight = [-83382, -116534, -127833, -94311];

% For each part i, failure exponent Li = sum_bombs ln(1-p) <= 0.
% We maximize probability of success = P(at least 2 parts destroyed).
% Using inclusion-exclusion with independence between parts:
%   Let qi = P(part i destroyed) = 1 - exp(Li)
%   Let fi = 1-qi = exp(Li)
%   P(success) = 1 - P(0 destroyed) - P(exactly 1 destroyed)
%              = 1 - prod_i fi - sum_i ( (1-fi) * prod_{j!=i} fj )
%              = 1 - prod_i fi - sum_i ( prod_{j!=i} fj - prod_i fj )
%              = 1 + 3*Fall - sum_i F_except_i
%   where Fall = prod_i fi = exp(sum_i Li),
%         F_except_i = prod_{j!=i} fj = exp(sum_{j!=i} Lj)
% We will approximate exp() by precomputing values for possible sums via table.
% Sums are integers in scaled-log space.

% Bounds for Li (most negative when using all bombs on a single part)
int: minLog = SCALE * (-10); % safe lower bound -10 (exp(-10) ~ 4.5e-5)
int: maxLog = 0;

% Variables
array[PARTS] of var 0..maxHeavy: xHeavy;   % number of heavy bombs assigned to part i
array[PARTS] of var 0..maxLight: xLight;   % number of light bombs assigned to part i

% Scaled log-failure sums for each part
array[PARTS] of var minLog..maxLog: L;

% Aggregate scaled log-failure sums for subsets used in inclusion-exclusion
var minLog..maxLog: L_all;
array[PARTS] of var minLog..maxLog: L_except;

% Discrete approximation tables for exp(s) where s in [minLog..0]
% We keep table only at integer points; use var int indices.
% expTable[t] = round(SCALE * exp(t / SCALE))
int: TABLE_MIN = -10000000; % corresponds to -10 in scaled units
int: TABLE_MAX = 0;
set of int: T = TABLE_MIN..TABLE_MAX;

array[T] of int: expTable =
  [ let { float: v = exp(int2float(t)/int2float(SCALE)) } in
    round(int2float(SCALE) * v)
    | t in T ];

% Derived "failure probabilities" scaled: fi = exp(Li)
array[PARTS] of var 0..SCALE: f;
var 0..SCALE: F_all;
array[PARTS] of var 0..SCALE: F_except;

% Scaled success probability (integer) to maximize
var 0..SCALE: P_success_scaled;

% Constraints
constraint sum(i in PARTS)(xHeavy[i]) <= maxHeavy;
constraint sum(i in PARTS)(xLight[i]) <= maxLight;

% Fuel constraint
constraint sum(i in PARTS)( fuelHeavy[i]*xHeavy[i] + fuelLight[i]*xLight[i] ) <= fuelLimit;

% Link logs per part: L[i] = sum bombs * ln(1-p) (scaled)
constraint
  forall(i in PARTS)(
    L[i] = logFailHeavy[i]*xHeavy[i] + logFailLight[i]*xLight[i]
  );

% Subset sums for inclusion-exclusion
constraint L_all = sum(i in PARTS)(L[i]);
constraint forall(i in PARTS)( L_except[i] = L_all - L[i] );

% Table lookup for exp: f[i] = exp(L[i]) (scaled), similarly for products
constraint forall(i in PARTS)( f[i] = expTable[L[i]] );
constraint F_all = expTable[L_all];
constraint forall(i in PARTS)( F_except[i] = expTable[L_except[i]] );

% Inclusion-exclusion: P(success) = 1 + 3*F_all - sum_i F_except[i]
% all scaled by SCALE
constraint
  P_success_scaled = max(0, min(SCALE, SCALE + 3*F_all - sum(i in PARTS)(F_except[i])));

% Objective
solve maximize P_success_scaled;

output [
  "Heavy bombs per part: ", show([xHeavy[i] | i in PARTS]), "\n",
  "Light bombs per part: ", show([xLight[i] | i in PARTS]), "\n",
  "Total heavy: ", show(sum(i in PARTS)(xHeavy[i])), " / ", show(maxHeavy), "\n",
  "Total light: ", show(sum(i in PARTS)(xLight[i])), " / ", show(maxLight), "\n",
  "Total fuel used: ", show(sum(i in PARTS)( fuelHeavy[i]*xHeavy[i] + fuelLight[i]*xLight[i] )), " / ", show(fuelLimit), "\n",
  "Approx. max success probability: ", show(int2float(P_success_scaled)/int2float(SCALE)), "\n"
];