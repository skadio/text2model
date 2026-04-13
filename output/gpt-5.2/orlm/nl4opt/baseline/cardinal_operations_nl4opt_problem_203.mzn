int: maxTreats = 1500;

int: labPapers = 7;
int: labTreats = 5;

int: goldPapers = 10;
int: goldTreats = 6;

int: minGold = 50;

var 0..maxTreats div labTreats: L;  % number of labradors
var 0..maxTreats div goldTreats: G; % number of golden retrievers

constraint labTreats * L + goldTreats * G <= maxTreats;
constraint G >= minGold;

% At most 60% of the dogs can be labradors: L / (L+G) <= 0.6  ->  5L <= 3G
constraint 5 * L <= 3 * G;

var int: totalPapers = labPapers * L + goldPapers * G;

solve maximize totalPapers;

output [
  "Labradors = ", show(L), "\n",
  "Golden retrievers = ", show(G), "\n",
  "Total newspapers = ", show(totalPapers), "\n",
  "Treats used = ", show(labTreats*L + goldTreats*G), " / ", show(maxTreats), "\n"
];