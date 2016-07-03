% minFunc
fprintf('Compiling minFunc files...\n');
mex -outdir minFunc minFunc/lbfgsC.c


% LLM2
fprintf('Compiling LLM2 files...\n');
mex -outdir LLM2/mex LLM2/mex/LLM2_pseudoC_singleloop.c

