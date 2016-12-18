function nchildren = findChildren(nparent, elements);

% This function finds the 1st order children's (i.e. child vertices) of the
% input parent vertex according to edge list specified by 'elements'.

col1 = elements(:, 1); % mother's side
col2 = elements(:, 2); % father's side

imchild = col1==nparent;
ifchild = col2==nparent;

mchild = col1(imchild);
fchild = col2(ifchild);

nchildren = horzcat(mchild, fchild);

end

