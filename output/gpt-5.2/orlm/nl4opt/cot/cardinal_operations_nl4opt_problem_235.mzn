% Parameters (with values embedded)
int: nA = 13;   % nitrogen per kg of fertilizer A
int: pA = 5;    % phosphoric acid per kg of fertilizer A
int: vAA = 6;   % vitamin A per kg of fertilizer A
int: vDA = 5;   % vitamin D per kg of fertilizer A

int: nB = 8;    % nitrogen per kg of fertilizer B
int: pB = 14;   % phosphoric acid per kg of fertilizer B
int: vAB = 6;   % vitamin A per kg of fertilizer B
int: vDB = 9;   % vitamin D per kg of fertilizer B

int: minN = 220;
int: minP = 160;
int: maxVA = 350;

% Variable bounds (derived safe upper bounds)
% From vitamin A constraint: 6*(xA + xB) <= 350 => xA + xB <= 58 (integer)
int: ub = 58;

% Variables
var 0..ub: xA;  % kg of fertilizer A
var 0..ub: xB;  % kg of fertilizer B
var 0..(vDA*ub + vDB*ub): totalVD;

% Constraints
constraint nA*xA + nB*xB >= minN;
constraint pA*xA + pB*xB >= minP;
constraint vAA*xA + vAB*xB <= maxVA;

constraint totalVD = vDA*xA + vDB*xB;

% Objective
solve minimize totalVD;

output [
  "xA(kg) = ", show(xA), "\n",
  "xB(kg) = ", show(xB), "\n",
  "minimum vitamin D = ", show(totalVD), "\n"
];