%% write_ave_gro.m
% * This function reads in a number of .gro files and writes out the
% average (or median, as default) atom struct and Box_dim to a file
% ave_conf.gro, as well as the variables atom_ave and Box_dim_ave below.
%
% * Note!! If chosing the 'average' option as a second argument, make sure
% your molecule does not overlap any PBC!!! If it does, just leave the
% default option which will compute the median position instead!
%
%% Version
% 2.082
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% # write_ave_gro(confstring) % Basic input arguments
% # write_ave_gro(confstring,'average')

function write_ave_gro(confstring,varargin)

% confstring='conf';

numConf=size(dir(strcat(confstring,'*')),1);

if numConf<3
    disp('Only found a few structure files, hence the average structure may not be statistically sound...')
end

atom_all=[];Box_dim_all=[];
for i=1:numConf
    atom = import_atom_gro(strcat(confstring,num2str(i-1),'.gro')); % Also gives Box_dim
    atom_all=[atom_all atom];
    Box_dim_all=[Box_dim_all;Box_dim];
end
Box_dim_ave=mean(Box_dim_all);

nAtoms=size(atom,2);atom_ave=atom;
if nargin>1 && strncmpi(varargin{1},'ave',3)
    for i=1:nAtoms
        disp('Computing average structure!!!!')
        [atom_ave(i).x]=mean([atom_all(i:nAtoms:end).x]);
        [atom_ave(i).y]=mean([atom_all(i:nAtoms:end).y]);
        [atom_ave(i).z]=mean([atom_all(i:nAtoms:end).z]);
    end
else
    for i=1:nAtoms
        disp('Computing median structure!!!!')
        [atom_ave(i).x]=median([atom_all(i:nAtoms:end).x]);
        [atom_ave(i).y]=median([atom_all(i:nAtoms:end).y]);
        [atom_ave(i).z]=median([atom_all(i:nAtoms:end).z]);
    end
end

write_atom_gro(atom_ave,Box_dim_ave,'ave_conf.gro');

assignin('caller','atom_ave',atom_ave);
assignin('caller','Box_dim_ave',Box_dim_ave);

end