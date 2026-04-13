% Parameters (with values embedded)
int: maxPrep = 100;
int: maxLabor = 700;
int: maxMat = 400;

% Resource requirements per unit
int: prepA = 1; int: laborA = 10; int: matA = 3;
int: prepB = 2; int: laborB = 4;  int: matB = 2;
int: prepC = 1; int: laborC = 5;  int: matC = 1;

% Big-M upper bounds derived from resources (safe tight bounds)
int: maxA = min(maxPrep div prepA, min(maxLabor div laborA, maxMat div matA)); % min(100,70,133)=70
int: maxB = min(maxPrep div prepB, min(maxLabor div laborB, maxMat div matB)); % min(50,175,200)=50
int: maxC = min(maxPrep div prepC, min(maxLabor div laborC, maxMat div matC)); % min(100,140,400)=100

% Piecewise profit per unit by total sales volume:
% A: 0..40 -> 10; 41..100 -> 9; 101..150 -> 8; >=151 -> 7
% B: 0..50 -> 6;  51..100 -> 4; >=101 -> 3
% C: 0..100 -> 5; >=101 -> 4 (but maxC=100 under resources, so only first tier is reachable)

% Variables
var 0..maxA: xA;
var 0..maxB: xB;
var 0..maxC: xC;

% Tier selection binaries
array[1..4] of var 0..1: yA; % tiers for A
array[1..3] of var 0..1: yB; % tiers for B
array[1..2] of var 0..1: yC; % tiers for C

% Effective per-unit profit chosen for each product
var 0..10: pA;
var 0..6:  pB;
var 0..5:  pC;

% Linearization variables for revenue = p * x
var 0..(10*maxA): revA;
var 0..(6*maxB):  revB;
var 0..(5*maxC):  revC;

% Constraints
constraint
  prepA*xA + prepB*xB + prepC*xC <= maxPrep /\
  laborA*xA + laborB*xB + laborC*xC <= maxLabor /\
  matA*xA + matB*xB + matC*xC <= maxMat;

% Exactly one tier selected per product
constraint sum(yA) = 1;
constraint sum(yB) = 1;
constraint sum(yC) = 1;

% Link quantities to tiers (enforce the sales volume ranges)
% A tiers: [0..40], [41..100], [101..150], [151..maxA]
constraint xA <= 40*yA[1] + 100*yA[2] + 150*yA[3] + maxA*yA[4];
constraint xA >= 0*yA[1]  + 41*yA[2]  + 101*yA[3] + 151*yA[4];

% B tiers: [0..50], [51..100], [101..maxB]
constraint xB <= 50*yB[1] + 100*yB[2] + maxB*yB[3];
constraint xB >= 0*yB[1]  + 51*yB[2]  + 101*yB[3];

% C tiers: [0..100], [101..maxC] (second tier infeasible here if maxC=100, but kept for completeness)
constraint xC <= 100*yC[1] + maxC*yC[2];
constraint xC >= 0*yC[1]   + 101*yC[2];

% Profit per unit determined by tier selection
constraint pA = 10*yA[1] + 9*yA[2] + 8*yA[3] + 7*yA[4];
constraint pB = 6*yB[1] + 4*yB[2] + 3*yB[3];
constraint pC = 5*yC[1] + 4*yC[2];

% Linearize rev = p * x using tier-based decomposition (since p depends on binaries)
constraint revA = 10*(xA*yA[1]) + 9*(xA*yA[2]) + 8*(xA*yA[3]) + 7*(xA*yA[4]);
constraint revB = 6*(xB*yB[1])  + 4*(xB*yB[2])  + 3*(xB*yB[3]);
constraint revC = 5*(xC*yC[1])  + 4*(xC*yC[2]);

% Objective
solve maximize revA + revB + revC;