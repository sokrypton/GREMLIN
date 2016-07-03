function seqs = converttonumericmsa(msa)
if(iscellstr(msa))
seqs =zeros(length(msa), length(msa{1}));
for i=1:length(msa)
  seqs(i,:) =aa2int(msa{i});
  seqs(i,(seqs(i,:)>20))=21;
end;
else
seqs =zeros(size(msa));
for i=1:length(msa)
  seqs(i,:) =aa2int(msa(i,:));
  seqs(i,(seqs(i,:)>20))=21;
end;
end;
