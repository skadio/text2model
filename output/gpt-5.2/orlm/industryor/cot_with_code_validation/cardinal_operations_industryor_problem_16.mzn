% Strategic bomber allocation to maximize probability that at least 2 of 4 parts are destroyed

%-----------------------
% Data (embedded)
%-----------------------
int: N = 4;
set of int: P = 1..N;

array[P] of int: dist_km = [450, 480, 540, 600];

array[P] of float: pH = [0.03, 0.10, 0.05, 0.05];
array[P] of float: pL = [0.08, 0.11, 0.12, 0.09];

int: maxH = 28;
int: maxL = 12;

float: fuel_limit = 10000.0;

float: speed_empty_km_per_l = 4.0;
float: speed_heavy_km_per_l = 2.0;
float: speed_light_km_per_l = 3.0;
float: takeoff_landing_l = 100.0;

array[P] of float: fuelH =
  [ takeoff_landing_l + int2float(dist_km[i])/speed_heavy_km_per_l
                      + int2float(dist_km[i])/speed_empty_km_per_l
  | i in P ];

array[P] of float: fuelL =
  [ takeoff_landing_l + int2float(dist_km[i])/speed_light_km_per_l
                      + int2float(dist_km[i])/speed_empty_km_per_l
  | i in P ];

%-----------------------
% Decision variables
%-----------------------
array[P] of var 0..maxH: xH;  % heavy bombs aimed at part i
array[P] of var 0..maxL: xL;  % light bombs aimed at part i

array[P] of var float: q;     % P(part i NOT destroyed)
array[P] of var float: s;     % P(part i IS destroyed) = 1 - q

% Enumerate subsets of destroyed parts (mask 0..15)
int: M = pow(2, N);                 % (fix: MiniZinc has no '<<' bitshift)
set of int: MASK = 0..M-1;
array[MASK] of var float: p_exact;  % probability exactly the destroyed-set = mask
var float: p_success;

%-----------------------
% Constraints
%-----------------------
constraint sum(i in P)(xH[i]) <= maxH;
constraint sum(i in P)(xL[i]) <= maxL;

constraint
  sum(i in P)(
    fuelH[i] * int2float(xH[i]) + fuelL[i] * int2float(xL[i])
  ) <= fuel_limit;

% Independence per part:
% q[i] = (1-pH[i])^xH[i] * (1-pL[i])^xL[i]
constraint
  forall(i in P)(
    q[i] = exp( int2float(xH[i]) * ln(1.0 - pH[i])
              + int2float(xL[i]) * ln(1.0 - pL[i]) )
  );

constraint forall(i in P)(s[i] = 1.0 - q[i]);

% Probability of each exact destroyed subset
% (fix: replace bitshift with pow(2, k))
constraint
  forall(mask in MASK)(
    p_exact[mask] =
      product(i in P)(
        if ((mask div pow(2, i-1)) mod 2 = 1) then s[i] else q[i] endif
      )
  );

% Probability of success = P(at least 2 parts destroyed)
function int: pop4(int: mask) =
  (mask mod 2)
  + ((mask div 2) mod 2)
  + ((mask div 4) mod 2)
  + ((mask div 8) mod 2);

constraint
  p_success = sum(mask in MASK where pop4(mask) >= 2)(p_exact[mask]);

%-----------------------
% Objective
%-----------------------
solve maximize p_success;