function apc_corrected_mat = apc(mat)

row_mean = mean(mat,2);
all_mean = mean(row_mean);
apc_corrected_mat = mat-(row_mean* (row_mean'))/all_mean;

%now just make everything positive and zero diag
%min_val_wo_diag = min(min(apc_corrected_mat-diag(diag(apc_corrected_mat))));
%apc_corrected_mat=apc_corrected_mat-min_val_wo_diag;
apc_corrected_mat = apc_corrected_mat-diag(diag(apc_corrected_mat));
