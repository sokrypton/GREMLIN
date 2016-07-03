function write_to_file(mat, fname, isfloat);
fid = fopen(fname, 'w');
for i=1:size(mat,1)
  for j=1:size(mat,2)
    if(~exist('isfloat', 'var') | isfloat==0)
      fprintf(fid, '%d ', mat(i,j));
    else
      fprintf(fid, '%.8f ', mat(i,j));
    end;
  end;
  fprintf(fid, '\n');
end;
fclose(fid);
