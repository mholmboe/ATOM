%% This small function let's you run Gromacs utilities in MATLAB
% * Note that you need to set your own gmx Gromacs path on line 16.
%
%% Version
% 2.11
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% # gmx('some utility','-someflag','some file/input') % Basic input syntax
% # gmx('editconf','-f','Ethanol.pdb','-o','out.pdb') % Calling the gmx editconf utility

function gmx(varargin)

if nargin>0
    tool=varargin{1};
    if nargin==1
        gmx_cmd=strcat(PATH2GMX,'/gmx',{' '},tool);
    elseif nargin==2
        gmx_cmd=strcat(PATH2GMX,'/gmx',{' '},tool,{' -h'});
    else
        gmx_cmd=strcat(PATH2GMX,'/gmx',{' '},tool);
        for i=2:2:nargin-1
            eval(strcat('inflag=varargin{',num2str(i),'};'));
            eval(strcat('invar=varargin{',num2str(i+1),'};'));
            eval("gmx_cmd=strcat(gmx_cmd,{' '},inflag,{' '},invar);");
        end
    end
else
    gmx_cmd=strcat(PATH2GMX,'/gmx',{' -h'});
end

system(char(gmx_cmd));

