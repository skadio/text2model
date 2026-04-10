% Weekly training schedule optimization (all data embedded)

int: maxTotalHours = 30;

int: minXminusY = 5;     % X >= Y + 5
int: maxZminusX = 10;    % |Z - X| <= 10

int: fatigueX = 10;
int: fatigueY = 15;
int: fatigueZ = 20;

/* Decision variables: integer hours for each exercise type */
var 0..maxTotalHours: X;
var 0..maxTotalHours: Y;
var 0..maxTotalHours: Z;

/* Constraints */
constraint X + Y + Z <= maxTotalHours;
constraint X >= Y + minXminusY;
constraint abs(Z - X) <= maxZminusX;

/* Objective: minimize total fatigue */
var 0..(maxTotalHours * max(fatigueX, max(fatigueY, fatigueZ))): totalFatigue;
constraint totalFatigue = fatigueX * X + fatigueY * Y + fatigueZ * Z;

solve minimize totalFatigue;

/* Output */
output [
  "Minimum total fatigue = ", show(totalFatigue), "\n",
  "X (cardio hours) = ", show(X), "\n",
  "Y (strength hours) = ", show(Y), "\n",
  "Z (flexibility hours) = ", show(Z), "\n"
];