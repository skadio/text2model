% Diabetes medicine production optimization (all data embedded)

int: imported_available = 300;
int: mrna_available = 400;

int: imported_per_A = 30;
int: mrna_per_A = 50;
int: imported_per_B = 40;
int: mrna_per_B = 30;

int: max_A = 5;

int: people_per_A = 12;
int: people_per_B = 8;

var 0..max_A: A;                 % doses of medicine A
var 0..1000: B;                  % doses of medicine B (upper bound large enough)

constraint imported_per_A * A + imported_per_B * B <= imported_available;
constraint mrna_per_A * A + mrna_per_B * B <= mrna_available;

constraint B > A;

var int: people_treated = people_per_A * A + people_per_B * B;

solve maximize people_treated;

output [
  "A doses = ", show(A), "\n",
  "B doses = ", show(B), "\n",
  "People treated = ", show(people_treated), "\n"
];