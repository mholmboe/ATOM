%% write_atom_pqr.m
% * This function writes an .pqr file from the atom struct
%
%% Version
% 2.09
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% # write_atom_pqr(atom,Box_dim,filename_out) % Basic input arguments
%
function write_atom_pqr(atom,Box_dim,filename,varargin)

% Have you done this?
nAtoms=size(atom,2)

if exist('[atom.charge]','var') && exist('[atom.radius]','var')
    disp('Charges and radius exist')
else
    for i=1:size(atom,2)
        [atom(i).radius] = radius_vdw([atom(i).type]);
    end
    
end


if nargin > 3
    short_r=cell2mat(varargin(1));
    long_r=cell2mat(varargin(2));
else
    short_r=1.25;
    long_r=2.25;
end

if nargin>5
    ffname=varargin(3);
    if nargin>6
        watermodel=varargin(4);
    else
        disp('Unknown watermodel, will try SPC/E')
        watermodel='SPC/E';
    end
    if strncmpi(ffname,'clayff',5)
        clayff_param(sort(unique([atom.type])),watermodel);
        Total_charge = check_clayff_charge(atom)
    elseif strcmpi(ffname,'interface')
        clayff_param(sort(unique([atom.type])),watermodel);
        Total_charge = check_interface_charge(atom)
    else
        disp('Unknown forcefield, will try clayff')
        clayff_param(sort(unique([atom.type])),watermodel);
        Total_charge = check_clayff_charge(atom)
    end
end
%     atom = charge_atom(atom,Box_dim,ffname,watermodel,short_r,long_r);
% atom = radius_atom(atom,ffname,watermodel);
% end

if abs(sum([atom.charge])) > 0.01
    disp('Not charge neutral system')
    sum([atom.charge])
end

if abs(round(sum([atom.charge]))-sum([atom.charge])) > 0.00001
    disp('Tweaking the charge')
    round(sum([atom.charge]))
    sum([atom.charge])
    qtot=sum([atom.charge]);
    charge=num2cell([atom.charge]-qtot/nAtoms); [atom.charge]=deal(charge{:});
end

indH= strncmpi([atom.type],'H',1);
[atom(indH).radius]=deal(0.1);

% .pqr format usually something like
% Field_name Atom_number Atom_name Residue_name Chain_ID Residue_number X Y Z Charge Radius

if regexp(filename,'.pqr') ~= false
    filename = filename;
else
    filename = strcat(filename,'.pqr');
end

Atom_section=cell(nAtoms,10);
fid = fopen(filename, 'wt');
fprintf(fid, '%s\n','COMPND    UNNAMED');
fprintf(fid, '%s\n','AUTHOR    GENERATED BY MATLAB');

% % %  1 -  6       Record name    "CRYST1"
% % %
% % %  7 - 15       Real(9.3)      a (Angstroms)
% % %
% % % 16 - 24       Real(9.3)      b (Angstroms)
% % %
% % % 25 - 33       Real(9.3)      c (Angstroms)
% % %
% % % 34 - 40       Real(7.2)      alpha (degrees)
% % %
% % % 41 - 47       Real(7.2)      beta (degrees)
% % %
% % % 48 - 54       Real(7.2)      gamma (degrees)
% % %
% % % 56 - 66       LString        Space group
% % %
% % % 67 - 70       Integer        Z value
% % %
% % %
% % % Example:
% % %
% % %          1         2         3         4         5         6         7
% % % 1234567890123456789012345678901234567890123456789012345678901234567890
% % % CRYST1  117.000   15.000   39.000  90.00  90.00  90.00 P 21 21 21    8

% % % CRYST1   31.188   54.090   20.000  90.00  90.00  90.00 P1          1
disp('Assuming P1 space group. Box can still be triclinic')
if length(Box_dim)==3
    fprintf(fid, '%6s%9.3f%9.3f%9.3f%7.2f%7.2f%7.2f %11s%4i\n','CRYST1', Box_dim(1:3), 90.00, 90.00, 90.00, 'P1', 1);
elseif length(Box_dim)==9
    a=Box_dim(1);
    b=Box_dim(2);
    c=Box_dim(3);
    xy=Box_dim(6);
    xz=Box_dim(8);
    yz=Box_dim(9);
    lx = a;
    ly = (b^2-xy^2)^.5;
    lz = (c^2 - xz^2 - yz^2)^0.5;
    alfa=rad2deg(acos((ly*yz+xy*xz)/(b*c)))
    beta=rad2deg(acos(xz/c));
    gamma=rad2deg(acos(xy/b));
    fprintf(fid, '%6s%9.3f%9.3f%9.3f%7.2f%7.2f%7.2f %11s%4i\n','CRYST1', a, b, c, alfa, beta, gamma, 'P1', 1);
else
    disp('No proper box_dim information')
end

% COLUMNS        DATA  TYPE    FIELD        DEFINITION
% -------------------------------------------------------------------------------------
% 1 -  6         Record name   "ATOM  "
% 7 - 11         Integer       serial       Atom  serial number.
% 13 - 16        Atom          name         Atom name.

%SKIPPED % 17             Character     altLoc       Alternate location indicator.

% 18 - 20        Residue name  resName      Residue name.

% 22             Character     chainID      Chain identifier.
% 23 - 26        Integer       resSeq       Residue sequence number.

%SKIPPED % 27             AChar         iCode        Code for insertion of residues.

% 31 - 38        Real(8.3)     x            Orthogonal coordinates for X in Angstroms.
% 39 - 46        Real(8.3)     y            Orthogonal coordinates for Y in Angstroms.
% 47 - 54        Real(8.3)     z            Orthogonal coordinates for Z in Angstroms.
% 55 - 60        Real(6.2)     occupancy    Occupancy.
% 61 - 66        Real(6.2)     tempFactor   Temperature  factor.
% 77 - 78        LString(2)    element      Element symbol, right-justified.
% 79 - 80        LString(2)    charge       Charge  on the atom.

% .pqr format usually something like
% Field_name Atom_number Atom_name Residue_name Chain_ID Residue_number X Y Z Charge Radius

[atom.type]=atom.fftype;

for i=1:size(atom,2)
    if strncmp(atom(i).type,{'Si'},2);atom(i).element={'Si'};atom(i).formalcharge=4;
    elseif strncmpi(atom(i).type,{'Al'},2);atom(i).element={'Al'};atom(i).formalcharge=3;
    elseif strncmpi(atom(i).type,{'Mg'},2);atom(i).element={'Mg'};atom(i).formalcharge=2;
    elseif strncmpi(atom(i).type,{'Mo'},2);atom(i).element={'Mo'};atom(i).formalcharge=6;
    elseif strncmpi(atom(i).type,{'Nb'},2);atom(i).element={'Nb'};atom(i).formalcharge=5;
    elseif strncmpi(atom(i).type,{'W'},2);atom(i).element={'W'};atom(i).formalcharge=6;
    elseif strncmpi(atom(i).type,{'P'},2);atom(i).element={'P'};atom(i).formalcharge=5;
    elseif strncmpi(atom(i).type,{'Fe'},2);atom(i).element={'Fe'};atom(i).formalcharge=3;
    elseif strncmpi(atom(i).type,{'Ow'},2);atom(i).element={'Ow'};atom(i).formalcharge=-2;
    elseif strncmpi(atom(i).type,{'O'},1);atom(i).element={'O'};atom(i).formalcharge=-2;
    elseif strncmpi(atom(i).type,{'Hw'},2);atom(i).element={'Hw'};atom(i).formalcharge=1;
    elseif strncmpi(atom(i).type,{'H'},1);atom(i).element={'H'};atom(i).formalcharge=1;
    elseif strncmpi(atom(i).type,{'K'},1);atom(i).element={'K'};atom(i).formalcharge=1;
    elseif strncmpi(atom(i).type,{'Na'},1);atom(i).element={'Na'};atom(i).formalcharge=0;
    elseif strncmpi(atom(i).type,{'Cl'},2);atom(i).element={'Cl'};atom(i).formalcharge=-1;
    elseif strncmpi(atom(i).type,{'Br'},2);atom(i).element={'Br'};atom(i).formalcharge=-1;
    elseif strncmpi(atom(i).type,{'Ca'},2);atom(i).element={'Ca'};atom(i).formalcharge=2;
    elseif strncmpi(atom(i).type,{'C'},1);atom(i).element={'C'};atom(i).formalcharge=0;
    else
        [atom(i).element]=atom(i).type;atom(i).formalcharge=0;
    end
end

[atom.type]=atom.element;

% [atom.type]=atom.element;
% ATOM      1   Na  Na A   1       9.160   6.810   1.420  1.00  1.00          Na 0
% ATOM      1  Si  MMT A   1       2.140   8.380   2.710  1.00  0.00           S

% .pqr format usually something like
% Field_name Atom_number Atom_name Residue_name Chain_ID Residue_number X Y Z Charge Radius
for i = 1:nAtoms
    Atom_section = ['ATOM  ', atom(i).index, atom(i).fftype, atom(i).resname, 'A',atom(i).molid, atom(i).x, atom(i).y, atom(i).z,round([atom(i).charge],5),atom(i).radius,atom(i).element,atom(i).formalcharge];
    %sprintf('%-6s%5i %4s %3s %1s%4i    %8.3f%8.3f%8.3f %8.5f%8.5f          %2s%2i\n',Atom_section{1:length(Atom_section)});
    fprintf(fid,'%-6s%5i %4s %3s %1s%4i    %8.3f%8.3f%8.3f %8.5f%8.5f          %2s%2i\r\n',Atom_section{1:length(Atom_section)});
end

% Write conect records

if nargin>3
    
    if size(varargin{1},1)<2
        
        if nargin>4
            short_r=varargin{1};
            long_r=varargin{2};
        else
            short_r=1.25;
            long_r=2.25;
        end
        
        short_r
        long_r
        
        %     atom=bond_angle_atom(atom,Box_dim,short_r,long_r);
        atom=bond_atom(atom,Box_dim,long_r);
        %     assignin('caller','Dist_matrix',Dist_matrix);
        assignin('caller','Bond_index',Bond_index);
        %     assignin('caller','Angle_index',Angle_index);
        assignin('caller','nBonds',nBonds);
        %     assignin('caller','nAngles',nAngles);
    else
        
        Bond_index=varargin{1};
        
    end
    
    B=[Bond_index(:,1:2); Bond_index(:,2) Bond_index(:,1)];
    b1=sortrows(B);
    for i=min(b1(:,1)):max(b1(:,1))
        ind=find(b1(:,1)==i);
        b2=b1(ind,2);
        fprintf(fid,'CONECT%5i%5i%5i%5i%5i%5i%5i',[i;b2]);
        fprintf(fid,'\n');
        if mod(i,100)==1
            i-1
        end
    end
    fprintf(fid,'MASTER    %5i%5i%5i%5i%5i%5i%5i%5i%5i%5i%5i%5i\n',[0    0    0    0    0    0    0    0 nAtoms    0 i    0]);
    fprintf(fid,'END');
    fprintf(fid,'\n');
else
    fprintf(fid, '%s\n','TER');
    fprintf(fid, '%s\n','ENDMDL');
end
fclose(fid);
disp('.pqr structure file written')

% assignin('caller','atom',atom);
% Total_charge=sum([atom.charge])


