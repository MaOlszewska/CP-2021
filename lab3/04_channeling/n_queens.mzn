include "alldifferent.mzn";
include "lex_lesseq.mzn";
int: N;
set of int: indexes = 1..N;

array[indexes] of var indexes: rows;


array[indexes,indexes] of var bool: qb;

constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in indexes]);
constraint alldifferent([rows[i] - i | i in indexes]);



constraint
    lex_lesseq(array1d(qb), [ qb[j,i] | i,j in 1..N ])
/\  lex_lesseq(array1d(qb), [ qb[i,j] | i in reverse(1..N), j in 1..N ])
/\  lex_lesseq(array1d(qb), [ qb[j,i] | i in 1..N, j in reverse(1..N) ])
/\  lex_lesseq(array1d(qb), [ qb[i,j] | i in 1..N, j in reverse(1..N) ])
/\  lex_lesseq(array1d(qb), [ qb[j,i] | i in reverse(1..N), j in 1..N ])
/\  lex_lesseq(array1d(qb), [ qb[i,j] | i,j in reverse(1..N) ])
/\  lex_lesseq(array1d(qb), [ qb[j,i] | i,j in reverse(1..N) ]);


constraint forall(i,j in indexes)(rows[i] = j <-> qb[i,j]);

solve satisfy; 
  
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];