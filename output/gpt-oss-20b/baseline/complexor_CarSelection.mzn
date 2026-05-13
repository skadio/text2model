int: ParticipantNum;
int: CarNum;
array[1..ParticipantNum, 1..CarNum] of int: InterestMatrix;
array[1..ParticipantNum, 1..CarNum] of var 0..1: assign;

constraint forall(p in 1..ParticipantNum) (
    sum(c in 1..CarNum) assign[p,c] <= 1
);
constraint forall(c in 1..CarNum) (
    sum(p in 1..ParticipantNum) assign[p,c] <= 1
);
constraint forall(p in 1..ParticipantNum, c in 1..CarNum) (
    assign[p,c] <= InterestMatrix[p,c]
);

solve maximize sum(p in 1..ParticipantNum, c in 1..CarNum) assign[p,c];

output [
    "Total assignments: ", show(sum(p in 1..ParticipantNum, c in 1..CarNum) assign[p,c]), "\n",
    "Assignment matrix:\n",
    concat([ show([assign[p,c] | c in 1..CarNum]) ++ "\n" | p in 1..ParticipantNum ])
];