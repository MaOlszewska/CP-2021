% Length of the sequence
int: N;

%%%%%%%%%%%%%% 
% TODO: VARIABLES        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The sequence itself, call it 'magic'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
array[0..N-1] of var 0..N-1: magic;
%%%%%%%%%%%%%%%%%%%%
% TODO: Constraints 
%%%%%%%%%%%%%%%%%%%%
constraint forall(i in 0..N-1)( magic[i] = sum(j in 0..N-1)( magic[j] == i));
constraint sum(magic) = N;
solve satisfy;
  
%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE OUTPUT  
%%%%%%%%%%%%%%%%%%%%%%%%
% - magic - magic sequence     
%%%%%%%%%%%%%%%%%%%%%%%%
output [ "magic sequence = ", show(magic),";\n"];
