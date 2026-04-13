% Parameters
int: nN_A = 13;
int: nP_A = 5;
int: vA_A = 6;
int: vD_A = 5;

int: nN_B = 8;
int: nP_B = 14;
int: vA_B = 6;
int: vD_B = 9;

int: minNitrogen = 220;
int: minPhosphoric = 160;
int: maxVitaminA = 350;

% Upper bounds derived from constraints (to keep variables bounded)
int: maxA_from_N = minNitrogen div nN_A; % floor
int: maxB_from_N = minNitrogen div nN_B; % floor
int: maxA_from_VA = maxVitaminA div vA_A;
int: maxB_from_VA = maxVitaminA div vA_B;

int: UB_A = maxA_from_VA; % Vitamin A is the tightest direct upper bound
int: UB_B = maxB_from_VA;

% Variables
var 0..UB_A: xA; % kg of fertilizer A (integer kg)
var 0..UB_B: xB; % kg of fertilizer B (integer kg)

var 0..(vD_A*UB_A + vD_B*UB_B): totalVitaminD;

% Constraints
constraint nN_A*xA + nN_B*xB >= minNitrogen;
constraint nP_A*xA + nP_B*xB >= minPhosphoric;
constraint vA_A*xA + vA_B*xB <= maxVitaminA;

constraint totalVitaminD = vD_A*xA + vD_B*xB;

% Objective
solve minimize totalVitaminD;