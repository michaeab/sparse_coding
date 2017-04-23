function deltaPhi = updatePhiAvg(r2update,a2update,eta)

% function deltaPhi = updatePhiAvg(r2update,a2update,eta)
%
% returns amount by which to update basis function.

% ONE RESIDUAL COLUMN FOR EACH WEIGHT
manyRs = repmat(r2update,[1 length(a2update)]);
% MULTIPLY EACH RESIDUAL COLUMN BY ITS CORRESPONDING WEIGHT
deltaPhi = eta.*bsxfun(@times,manyRs,a2update');

end