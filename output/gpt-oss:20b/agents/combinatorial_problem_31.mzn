include "globals.mzn";

/* ------------------------------------------------------------------ */
/*  Input parameters                                                 */
/* ------------------------------------------------------------------ */
int: num_people;                            % number of people in the program

/*  compatibility[i,j] = 1  ⇔  person i can donate to person j   */
array[1..num_people,1..num_people] of int: compatible;

/* ------------------------------------------------------------------ */
/*  Decision variables                                               */
/* ------------------------------------------------------------------ */

/* x[i,j] = 1 if person i donates to person j, 0 otherwise */
array[1..num_people,1..num_people] of var 0..1: x;

/* p[i] = 1 if person i participates (donates AND receives)      */
array[1..num_people] of var 0..1: p;

/* ------------------------------------------------------------------ */
/*  Constraints                                                      */
/* ------------------------------------------------------------------ */

/* Every participant donates exactly one kidney */
constraint forall(i in 1..num_people) (
    sum(j in 1..num_people)(x[i,j]) = p[i]
);

/* Every participant receives exactly one kidney */
constraint forall(j in 1..num_people) (
    sum(i in 1..num_people)(x[i,j]) = p[j]
);

/* Respect the compatibility matrix (and disallow self‑donation) */
constraint forall(i,j in 1..num_people) (
    x[i,j] <= compatible[i,j]
);
constraint forall(i in 1..num_people) (
    x[i,i] = 0
);

/* ------------------------------------------------------------------ */
/*  Objective: maximise the number of exchanges (participants)       */
/* ------------------------------------------------------------------ */
solve maximize sum(i in 1..num_people)(p[i]);

/* ------------------------------------------------------------------ */
/*  Output                                                          */
/* ------------------------------------------------------------------ */
output [
    "Number of participants: ", show(sum(i in 1..num_people)(p[i])), "\n",
    "Exchanges (donor -> recipient):\n",
    concat([ if x[i,j] == 1 then show([i,j]) ++ "\n" else "" endif
            | i in 1..num_people, j in 1..num_people ])
];