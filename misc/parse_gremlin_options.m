function options = parse_gremlin_options(opt_param)
options.verbose = 0; % Turn off verbose output of optimizer
options.useMex = 1;
options.param = 'F';
options.edges = [];
options.lambda_l2=0.2;
options.lambda_bias=0.01;
options.MaxIter=50;
options.apc=1;
options.CORR=40;
options.method='cg';
options.lambda_l2_scale_by_length=1;
options.reweight=0.2;
options.multiplicative_lam=0;
options.progTol=1e-6;
options.save_mat=0;
options.save_model='';

for i=1:2:length(opt_param)-1
  options=setfield(options, opt_param{i}, opt_param{i+1});
end

%the following lines convert command line args to numeric types when compiled exec is used.
if (isfield(options, 'verbose'))
  if(ischar(options.verbose))
    options.verbose= str2num(options.verbose);
  end;
end;
if (isfield(options, 'apc'))
  if(ischar(options.apc))
    options.apc= str2num(options.apc);
  end;
end;
if (isfield(options, 'CORR'))
  if(ischar(options.CORR))
    options.CORR= str2double(options.CORR);
  end;
end;
if (isfield(options, 'MaxIter'))
  if(ischar(options.MaxIter))
    options.MaxIter = str2double(options.MaxIter);
  end;
end;
if (isfield(options, 'lambda_l2_scale_by_length'))
  if(ischar(options.lambda_l2_scale_by_length))
    options.lambda_l2_scale_by_length = str2double(options.lambda_l2_scale_by_length);
  end;
end;
 if(isfield(options, 'lambda_bias'))
   if(ischar(options.lambda_bias))
     options.lambda_bias = str2double(options.lambda_bias);
   end;
 end;
 if(isfield(options, 'lambda_l2'))
   if(ischar(options.lambda_l2))
     options.lambda_l2 = str2double(options.lambda_l2);
   end;
 end;
 if(options.verbose==1)
   options
 end;
 if(isfield(options, 'save_mat'))
   if(ischar(options.save_mat))
     options.save_mat = str2num(options.save_mat);
   end;
 end;
 if(isfield(options, 'lambda_matf'))
   options.lambda_mat = load(options.lambda_matf);
 end;
 if(isfield(options, 'lambda_mat_multiplier'))
   if(ischar(options.lambda_mat_multiplier))
     options.lambda_mat_multiplier = str2double(options.lambda_mat_multiplier);
   else
     options.lambda_mat_multiplier = options.lambda_mat_multiplier;
   end
 end
 if(isfield(options, 'lambda_mat_multiplier') & isfield(options, 'lambda_mat'))
   options.lambda_mat = options.lambda_mat.*options.lambda_mat_multiplier;
 end;
 if(isfield(options, 'reweight'))
   if(ischar(options.reweight))
     options.reweight = str2double(options.reweight);
   else
     options.reweight = options.reweight;
   end;
 end;
