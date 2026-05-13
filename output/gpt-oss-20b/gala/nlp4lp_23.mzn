include "globals.mzn";

/*--- Input data --------------------------------------------------------*/
int: T;                       % number of years (3)
int: K;                       % number of worker types (3)

array[1..T, 1..K] of int: Requirement;   % required manpower (strength units)
array[1..K] of int: Strength;            % strength of one worker of each type
array[1..K] of int: Recruit;             % max recruitment per year for each type
array[1..K] of int: CostRedundancy;      % cost per redundant worker (type‑dependent)
array[1..K] of int: CostOverman;         % cost per overman (type‑dependent)
array[1..K] of int: CostShort;           % cost per short‑worked worker (type‑dependent)

int: NumOverman;            % total allowed overmanning across all types & years
int: NumShortwork;          % total allowed short‑working workers across all types & years

/*--- Decision variables -----------------------------------------------*/
array[1..T, 1..K] of var 0..10000: R;     % recruits in year t, type k
array[1..T, 1..K] of var 0..10000: Red;   % redundancies in year t, type k
array[1..T, 1..K] of var 0..10000: S;     % short‑worked workers in year t, type k

array[1..T, 1..K] of var 0..10000: Curr; % workforce available in year t before redundancies
array[1..T+1, 1..K] of var 0..10000: F;  % workforce at start of each year
array[1..T, 1..K] of var 0..10000: Over; % over‑manned workers in year t, type k

/*--- Derived data -----------------------------------------------------*/
function var int: reqEmp(int: t, int: k) =
        (Requirement[t,k] + Strength[k] - 1) div Strength[k];  % ceil division

/*--- Constraints -------------------------------------------------------*/
% Initial workforce is zero
constraint forall(k in 1..K)(F[1,k] == 0);

/* Workforce evolution and availability */
constraint forall(t in 1..T, k in 1..K)(
        Curr[t,k] == F[t,k] + R[t,k]
);

% Recruits limited per year
constraint forall(t in 1..T, k in 1..K)(
        R[t,k] <= Recruit[k]
);

/* Short‑working must not exceed available workforce */
constraint forall(t in 1..T, k in 1..K)(
        S[t,k] <= Curr[t,k]
);

/* Meet required strength (short workers count as 0.5 strength) */
constraint forall(t in 1..T, k in 1..K)(
        Strength[k] * (Curr[t,k] - 0.5 * S[t,k]) >= Requirement[t,k]
);

/* Redundancies cannot exceed non‑short workforce */
constraint forall(t in 1..T, k in 1..K)(
        Red[t,k] <= Curr[t,k] - S[t,k]
);

/* Update workforce for next year */
constraint forall(t in 1..T, k in 1..K)(
        F[t+1,k] == Curr[t,k] - Red[t,k]
);

/* Over‑manning definition and limit */
constraint forall(t in 1..T, k in 1..K)(
        Over[t,k] == Curr[t,k] - S[t,k] - reqEmp(t,k)
);
constraint forall(t in 1..T, k in 1..K)(Over[t,k] >= 0);
constraint sum(t in 1..T, k in 1..K)(Over[t,k]) <= NumOverman;

/* Short‑working limit per year (total across all types) */
constraint forall(t in 1..T)(
        sum(k in 1..K)(S[t,k]) <= NumShortwork
);

/*--- Objective --------------------------------------------------------*/
solve minimize sum(t in 1..T, k in 1..K)(CostRedundancy[k] * Red[t,k]);

/*--- Output -----------------------------------------------------------*/
output [
    "Year   Type  Recruits  Short  Redundancy  Workforce\n",
    forall(t in 1..T)(
        forall(k in 1..K)(
            show(t) ++ " " ++ show(k) ++ " " ++
            show(R[t,k]) ++ " " ++
            show(S[t,k]) ++ " " ++
            show(Red[t,k]) ++ " " ++
            show(F[t+1,k]) ++ "\n"
        )
    ),
    "\nTotal redundancy cost = ", show(sum(t in 1..T, k in 1..K)(CostRedundancy[k] * Red[t,k])), "\n"
];