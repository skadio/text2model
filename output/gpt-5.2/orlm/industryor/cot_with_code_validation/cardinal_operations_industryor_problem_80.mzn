% Parking on two sides: minimize occupied street length = max(total length on each side)
% Data embedded as required.

int: N = 15;
set of int: CARS = 1..N;

% Use integer centimeters to avoid float issues with Gecode float linear constraints
array[CARS] of int: Lcm =
  [400, 450, 500, 410, 240, 520, 370, 350, 320, 450, 230, 330, 380, 460, 300];

% Set to 3000 to enforce "one side cannot exceed 30 meters"; set to sum(Lcm) to disable.
int: MAX_SIDE_CM = 3000;

int: sumLcm = sum(i in CARS)(Lcm[i]);

% Decision: side assignment
array[CARS] of var bool: x;     % x[i]=true -> side A, false -> side B

% Totals (in cm)
var 0..sumLcm: LAcm = sum(i in CARS)(Lcm[i] * bool2int(x[i]));
var 0..sumLcm: LBcm = sum(i in CARS)(Lcm[i] * (1 - bool2int(x[i])));

% Occupied street length (in cm) is the maximum of the two sides
var 0..sumLcm: Tcm;

constraint Tcm >= LAcm;
constraint Tcm >= LBcm;

% Capacity constraint on one side (side A)
constraint LAcm <= MAX_SIDE_CM;

solve minimize Tcm;

output [
  "T (m) = ", show(Tcm / 100.0), "\n",
  "LA (m) = ", show(LAcm / 100.0), "\n",
  "LB (m) = ", show(LBcm / 100.0), "\n",
  "Side A cars: ", show([i | i in CARS where fix(x[i])]), "\n",
  "Side B cars: ", show([i | i in CARS where not fix(x[i])]), "\n"
];