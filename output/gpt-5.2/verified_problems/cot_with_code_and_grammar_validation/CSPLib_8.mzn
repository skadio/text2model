% Parameters
int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

array[1..n_containers] of int: width;
array[1..n_containers] of int: length;
array[1..n_containers] of 1..n_classes: class;

array[1..n_classes, 1..n_classes] of int: separation;

% Variables
array[1..n_containers] of var 0..deck_width: x;   % left coordinate (across deck)
array[1..n_containers] of var 0..deck_length: y;  % bottom coordinate (along deck)

% Constraints
% Non-negativity (already implied by domains) and in-deck placement
constraint
  forall(i in 1..n_containers) (
    x[i] + width[i] <= deck_width /\
    y[i] + length[i] <= deck_length
  );

% Non-overlap and separation constraints (axis-aligned rectangles)
% For each pair of containers i<j, enforce at least one of:
%  - i is left of j by required cross-deck separation
%  - j is left of i by required cross-deck separation
%  - i is below j by required along-deck separation
%  - j is below i by required along-deck separation
constraint
  forall(i in 1..n_containers, j in i+1..n_containers) (
    let {
      int: sep_ij = separation[class[i], class[j]]
    } in
      (x[i] + width[i] + sep_ij <= x[j]) \/
      (x[j] + width[j] + sep_ij <= x[i]) \/
      (y[i] + length[i] + sep_ij <= y[j]) \/
      (y[j] + length[j] + sep_ij <= y[i])
  );

% Objective
solve satisfy;