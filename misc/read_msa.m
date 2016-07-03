function X  = read_msa(fname_train)
[names,seqs]= textread(fname_train, '%s %s');
if(isempty(seqs{1}))%msa doesn't have names
  seqs = textread(fname_train, '%s');
end;
X= converttonumericmsa((seqs)); % now reads in msa file.
if (min(min(X)) == 0) 
   X = X + 1;
end
