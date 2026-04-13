include "globals.mzn";

% Data (embedded from the problem description)
int: matAvail = 300;     % imported material available
int: mrnaAvail = 400;    % mRNA available

int: matA = 30;  int: mrnaA = 50;  int: treatA = 12;
int: matB = 40;  int: mrnaB = 30;  int: treatB = 8;

int: maxA = 5;

% Decision variables: number of doses
var 0..maxA: a;          % doses of medicine A
var 0..20: b;            % doses of medicine B (safe upper bound from material: 40*b <= 300 => b <= 7, plus slack)

% Resource constraints
constraint matA * a + matB * b <= matAvail;
constraint mrnaA * a + mrnaB * b <= mrnaAvail;

% Production constraints
constraint b > a;

% Objective: maximize people treated
var 0..1000: treated;
constraint treated = treatA * a + treatB * b;

solve maximize treated;

output [
  "Doses A = ", show(a), "\n",
  "Doses B = ", show(b), "\n",
  "People treated = ", show(treated), "\n",
  "Imported material used = ", show(matA*a + matB*b), " / ", show(matAvail), "\n",
  "mRNA used = ", show(mrnaA*a + mrnaB*b), " / ", show(mrnaAvail), "\n"
];