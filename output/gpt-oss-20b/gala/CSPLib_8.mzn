include "globals.mzn";

/* ---------- data ---------- */
int: deck_width;
int: deck_length;
int: n_containers;
int: n_classes;

array[1..n_classes]          of int: width_c;    % width of each class
array[1..n_classes]          of int: length_c;   % length of each class
array[1..n_containers]       of int: cls;         % class of each container
array[1..n_classes,1..n_classes] of int: sep_matrix; % minimum separation between classes

/* ---------- variables ---------- */
array[1..n_containers] of var 0..deck_width : x;   % lower‑left x‑coordinate
array[1..n_containers] of var 0..deck_length: y;   % lower‑left y‑coordinate

/* ---------- placement constraints ---------- */
/* containers stay inside the deck */
constraint
  forall(i in 1..n_containers) (
    x[i] + width_c[cls[i]] <= deck_width /\
    y[i] + length_c[cls[i]] <= deck_length
  );

/* non‑overlap and class separation */
constraint
  forall(i in 1..n_containers where i < n_containers) (
    forall(j in i+1..n_containers) (
      let { int: sep = sep_matrix[cls[i],cls[j]] } in
      (x[i] + width_c[cls[i]] + sep <= x[j]) \/
      (x[j] + width_c[cls[j]] + sep <= x[i]) \/
      (y[i] + length_c[cls[i]] + sep <= y[j]) \/
      (y[j] + length_c[cls[j]] + sep <= y[i])
    )
  );

/* ---------- solve ---------- */
solve satisfy;

/* ---------- output ---------- */
output [
  "Possible placement:\n",
  concat([ "Container ", show(i), ": class ", show(cls[i]),
           " at (", show(x[i]), ",", show(y[i]), ")\n" | i in 1..n_containers ])
];