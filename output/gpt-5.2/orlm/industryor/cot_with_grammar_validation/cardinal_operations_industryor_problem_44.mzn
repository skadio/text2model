% Parameters
int: nProd = 3;
set of int: P = 1..nProd;

int: prepAvail = 100;
int: laborAvail = 700;
int: matAvail = 400;

array[P] of int: prepReq  = [1, 2, 1];
array[P] of int: laborReq = [10, 4, 5];
array[P] of int: matReq   = [3, 2, 1];

% Piecewise profit (per unit) with volume thresholds
int: nSegA = 4;
array[1..nSegA] of int: loA = [0, 40, 100, 150];
array[1..nSegA] of int: hiA = [40, 100, 150, 10000];
array[1..nSegA] of int: prA = [10, 9, 8, 7];

int: nSegB = 3;
array[1..nSegB] of int: loB = [0, 50, 100];
array[1..nSegB] of int: hiB = [50, 100, 10000];
array[1..nSegB] of int: prB = [6, 4, 3];

int: nSegC = 2;
array[1..nSegC] of int: loC = [0, 100];
array[1..nSegC] of int: hiC = [100, 10000];
array[1..nSegC] of int: prC = [5, 4];

% Upper bounds (from resources)
int: ubA = min(prepAvail div prepReq[1], min(laborAvail div laborReq[1], matAvail div matReq[1]));
int: ubB = min(prepAvail div prepReq[2], min(laborAvail div laborReq[2], matAvail div matReq[2]));
int: ubC = min(prepAvail div prepReq[3], min(laborAvail div laborReq[3], matAvail div matReq[3]));

% Variables
var 0..ubA: xA;
var 0..ubB: xB;
var 0..ubC: xC;

var 0..1: segA1;
var 0..1: segA2;
var 0..1: segA3;
var 0..1: segA4;

var 0..1: segB1;
var 0..1: segB2;
var 0..1: segB3;

var 0..1: segC1;
var 0..1: segC2;

var int: profit;

% Constraints
constraint
  prepReq[1]*xA + prepReq[2]*xB + prepReq[3]*xC <= prepAvail;

constraint
  laborReq[1]*xA + laborReq[2]*xB + laborReq[3]*xC <= laborAvail;

constraint
  matReq[1]*xA + matReq[2]*xB + matReq[3]*xC <= matAvail;

% Exactly one segment chosen per product
constraint segA1 + segA2 + segA3 + segA4 = 1;
constraint segB1 + segB2 + segB3 = 1;
constraint segC1 + segC2 = 1;

% Enforce segment bounds on volumes (big-M with segment indicator)
constraint xA >= loA[1]*segA1 + loA[2]*segA2 + loA[3]*segA3 + loA[4]*segA4;
constraint xA <= hiA[1]*segA1 + hiA[2]*segA2 + hiA[3]*segA3 + hiA[4]*segA4;

constraint xB >= loB[1]*segB1 + loB[2]*segB2 + loB[3]*segB3;
constraint xB <= hiB[1]*segB1 + hiB[2]*segB2 + hiB[3]*segB3;

constraint xC >= loC[1]*segC1 + loC[2]*segC2;
constraint xC <= hiC[1]*segC1 + hiC[2]*segC2;

% Profit definition (uniform per-unit profit within the chosen segment)
constraint
  profit =
    xA * (prA[1]*segA1 + prA[2]*segA2 + prA[3]*segA3 + prA[4]*segA4) +
    xB * (prB[1]*segB1 + prB[2]*segB2 + prB[3]*segB3) +
    xC * (prC[1]*segC1 + prC[2]*segC2);

% Objective
solve maximize profit;