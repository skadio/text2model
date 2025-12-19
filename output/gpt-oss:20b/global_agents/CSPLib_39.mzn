include "globals.mzn";

/* ----- Data ----- */
int: num_pieces;                     % number of pieces
int: num_players;                    % number of players
array[1..num_pieces] of int: duration;            % duration of each piece
array[1..num_players, 1..num_pieces] of int: rehearsal; % 1 = player participates in the piece

/* ----- Decision variables ----- */
array[1..num_pieces] of var 1..num_pieces: order;   % permutation of the pieces
array[1..num_pieces] of var 1..num_pieces: pos;    % inverse permutation (pos[order[i]] = i)

% Boolean array: player p participates in piece k
array[1..num_players, 1..num_pieces] of var bool: involved;
constraint
  forall(p in 1..num_players, k in 1..num_pieces)
    involved[p,k] = (rehearsal[p,k] == 1);

/* ----- Constraints ----- */
% order is a permutation
constraint all_different(order);
constraint forall(i in 1..num_pieces)( pos[order[i]] == i );

% inside[p,k] = true iff piece k is between the first and last piece that player p plays
array[1..num_players, 1..num_pieces] of var bool: inside;
constraint
  forall(p in 1..num_players, k in 1..num_pieces)
    inside[p,k] =
      ( sum(i in 1..num_pieces) (
          bool2int( involved[p,i] /\ (pos[i] <= pos[k]) )
        ) >= 1 )
      /\ 
      ( sum(i in 1..num_pieces) (
          bool2int( involved[p,i] /\ (pos[i] >= pos[k]) )
        ) >= 1 );

% presence[p] = total time player p is present during rehearsal
array[1..num_players] of var int: presence;
constraint
  forall(p in 1..num_players)
    presence[p] = sum(k in 1..num_pieces)(
                    duration[k] * bool2int( inside[p,k] )
                 );

% total waiting time (constant offset ignored because it does not affect the optimum)
var int: total_wait;
constraint total_wait = sum(p in 1..num_players)( presence[p] );

/* ----- Solve ----- */
solve minimize total_wait;

/* ----- Output ----- */
output [
  "Order of pieces = ", show(order), "\n",
  "Total waiting time = ", show(total_wait), "\n"
];