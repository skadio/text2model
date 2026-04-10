include "globals.mzn";

/************ Data (embedded) ************/
int: nPlatforms = 3;
set of int: PLAT = 1..nPlatforms;

array[PLAT] of int: cost   = [1200, 2000, 4000];  % 1=Pi TV, 2=Beta Video, 3=Gamma Live
array[PLAT] of int: reach  = [2000, 5000, 9000];

int: budget = 20000;

/************ Decision variables ************/
/* Let N be the total number of commercials. Upper bound is budget / min(cost). */
int: Nmax = budget div min(cost);
var 0..Nmax: N;

/* Each commercial chooses a platform (1..3). */
array[1..Nmax] of var PLAT: plat;

/* Counts per platform */
var 0..Nmax: nPi;
var 0..Nmax: nBeta;
var 0..Nmax: nGamma;

/************ Counting constraints (hint-based) ************/
/* Only the first N entries are "active"; the rest are forced to Pi TV (arbitrary). */
constraint forall(i in 1..Nmax)( i > N -> plat[i] = 1 );

constraint count(plat, 1, nPi);
constraint count(plat, 2, nBeta);
constraint count(plat, 3, nGamma);

/* Since inactive entries are set to 1, adjust effective counts */
var 0..Nmax: nPi_eff = nPi - (Nmax - N);
var 0..Nmax: nBeta_eff = nBeta;
var 0..Nmax: nGamma_eff = nGamma;

constraint nPi_eff + nBeta_eff + nGamma_eff = N;

/************ Business constraints ************/
constraint sum(i in 1..N)( cost[plat[i]] ) <= budget;

constraint nBeta_eff <= 8;
constraint 3 * nGamma_eff <= N;   % at most one third on Gamma Live
constraint 5 * nPi_eff >= N;      % at least 20% on Pi TV

/************ Objective ************/
var int: totalReach = sum(i in 1..N)( reach[plat[i]] );
solve maximize totalReach;

/************ Output ************/
output [
  "N = ", show(N), "\n",
  "Pi TV commercials = ", show(nPi_eff), "\n",
  "Beta Video commercials = ", show(nBeta_eff), "\n",
  "Gamma Live commercials = ", show(nGamma_eff), "\n",
  "Total cost = ", show(sum(i in 1..N)( cost[plat[i]] )), "\n",
  "Total reach = ", show(totalReach), "\n"
];