%% occupancy_atom.m
% * This function finds the occupancy all sites, within a certain rmax.
%
%% Version
% 3.00
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% * atom = occupancy_atom(atom,Box_dim) % Basic input arguments
% * atom = occupancy_atom(atom,Box_dim,0.85) % Sets rmax to custom value

function atom = occupancy_atom(atom,Box_dim,varargin) % ,rmax);

occupancy_atom=atom;

if size(Box_dim,2) == 6
    Box_dim=Cell2Box_dim(Box_dim); % Box_dim is actually the 1x6 Cell varialbe containing angles instead of tilt factors
end

dist_matrix=dist_matrix_atom(atom,Box_dim);

disp('Will calculate the occupancy of all sites, with a r_min of:');
if nargin==2
    rmax=1.0;
else
    rmax=varargin{1};
end

i=1;
while i < size(occupancy_atom,2)+1
    rmind=find(dist_matrix(:,i)<rmax)';
    [occupancy_atom(i).occupancy]=1/numel(rmind);
    i=i+1;
    if mod(i,1000)==1
        if i > 1
            i-1;
        end
    end
end

assignin('caller','occupancy',[occupancy_atom.occupancy]');

atom=update_atom(occupancy_atom);

end

