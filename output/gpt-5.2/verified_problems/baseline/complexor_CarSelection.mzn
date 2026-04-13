int: ParticipantNum;
int: CarNum;

array[1..ParticipantNum, 1..CarNum] of 0..1: InterestMatrix;

array[1..ParticipantNum, 1..CarNum] of var 0..1: assign;

constraint
  forall(p in 1..ParticipantNum) (
    sum(c in 1..CarNum)(assign[p,c]) <= 1
  );

constraint
  forall(p in 1..ParticipantNum, c in 1..CarNum) (
    assign[p,c] <= InterestMatrix[p,c]
  );

solve maximize sum(p in 1..ParticipantNum, c in 1..CarNum)(assign[p,c]);

output [
  "TotalAssignments = ", show(sum(p in 1..ParticipantNum, c in 1..CarNum)(assign[p,c])), ";\n",
  "AssignMatrix = [|\n"
] ++
[
  concat([ show(assign[p,c]) ++ if c < CarNum then " " else "" endif
         | c in 1..CarNum ]) ++ "|\n"
  | p in 1..ParticipantNum
] ++
[
  "];\n"
];