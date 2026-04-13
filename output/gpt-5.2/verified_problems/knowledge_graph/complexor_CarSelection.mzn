int: ParticipantNum;
int: CarNum;

set of int: PARTICIPANTS = 1..ParticipantNum;
set of int: CARS = 1..CarNum;

array[PARTICIPANTS, CARS] of int: InterestMatrix; % 0/1

array[PARTICIPANTS, CARS] of var 0..1: assign;

constraint
  forall(p in PARTICIPANTS) (
    sum(c in CARS)(assign[p,c]) <= 1
  );

constraint
  forall(p in PARTICIPANTS, c in CARS) (
    assign[p,c] <= InterestMatrix[p,c]
  );

var 0..ParticipantNum: total_assignments = sum(p in PARTICIPANTS, c in CARS)(assign[p,c]);

solve maximize total_assignments;

output [
  "total_assignments=", show(total_assignments), "\n",
  "assign=\n",
  concat([ concat([ if fix(assign[p,c]) = 1 then "1 " else "0 " endif | c in CARS]) ++ "\n"
         | p in PARTICIPANTS ])
];