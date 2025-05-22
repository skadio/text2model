% Parameters
int: deck_width;
int: deck_length;

int: n_containers;
int: n_classes;

array[1..n_classes] of int: width;          % width of each container class
array[1..n_classes] of int: length;         % length of each container class

array[1..n_containers] of int: class_of;    % class index of each container (1..n_classes)

array[1..n_classes, 1..n_classes] of int: separation;   % minimum required separations

int: deck_max = max(deck_width, deck_length);            % utility constant


% Variables
array[1..n_containers] of var 0..deck_width  : x;        % left-side (width axis) coordinate
array[1..n_containers] of var 0..deck_length : y;        % lower-side (length axis) coordinate

array[1..n_containers] of var bool           : rot;      % rotation flag  (false = no rotation)

array[1..n_containers] of var 1..deck_max    : w_eff;    % effective width after rotation
array[1..n_containers] of var 1..deck_max    : l_eff;    % effective length after rotation


% Constraints

% Effective dimensions, depending on rotation and class
constraint
  forall(i in 1..n_containers) (
      w_eff[i] = (1 - bool2int(rot[i])) * width [class_of[i]]
               + bool2int(rot[i])       * length[class_of[i]] /\
      l_eff[i] = (1 - bool2int(rot[i])) * length[class_of[i]]
               + bool2int(rot[i])       * width [class_of[i]]
  );

% Keep every container completely inside the deck
constraint
  forall(i in 1..n_containers) (
      x[i] + w_eff[i] <= deck_width /\
      y[i] + l_eff[i] <= deck_length
  );

% Non-overlap and class-dependent separation requirements
constraint
  forall(i, j in 1..n_containers where i < j) (
        (x[i] + w_eff[i] + separation[class_of[i], class_of[j]] <= x[j]) \/
        (x[j] + w_eff[j] + separation[class_of[i], class_of[j]] <= x[i]) \/
        (y[i] + l_eff[i] + separation[class_of[i], class_of[j]] <= y[j]) \/
        (y[j] + l_eff[j] + separation[class_of[i], class_of[j]] <= y[i])
  );


% Objective
solve satisfy;