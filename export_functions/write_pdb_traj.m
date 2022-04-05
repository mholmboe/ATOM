%% write_pdb_traj.m
% * This function writes a .pdb trajectory
%
%% Version
% 2.11
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% # write_pdb_traj(atom,traj,Box_dim,filename_out) % Basic input arguments
%
function write_pdb_traj(atom,traj,Box_dim,filename_out)

if regexp(filename_out,'.pdb') ~= false
    filename_out = filename_out;
else
    filename_out = strcat(filename_out,'.pdb');
end

Frames=size(traj,1);
nFrames=1:Frames;
nAtoms=size(atom,2);
Atom_section=cell(nAtoms,10);

for i=1:size(atom,2)
    if strncmp(atom(i).type,{'Si'},2);atom(i).element={'Si'};atom(i).formalcharge=4;
    elseif strncmpi(atom(i).type,{'Al'},2);atom(i).element={'Al'};atom(i).formalcharge=3;
    elseif strncmpi(atom(i).type,{'Mg'},2);atom(i).element={'Mg'};atom(i).formalcharge=2;
    elseif strncmpi(atom(i).type,{'Fe'},2);atom(i).element={'Fe'};atom(i).formalcharge=3;
    elseif strncmpi(atom(i).type,{'O'},1);atom(i).element={'O'};atom(i).formalcharge=-2;
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

% ATOM      1   Na  Na A   1       9.160   6.810   1.420  1.00  1.00          Na 0
% ATOM      1  Si  MMT A   1       2.140   8.380   2.710  1.00  0.00           S

% Remove this if you do not need it...
for i = 1:nAtoms
    if size(atom(i).type{1},2) > 4
        disp('Hey, this atom type name is actually too long for pdb')
        disp('chopping it down to 4 characters')
        [atom(i).index atom(i).type]
        atom(i).type=atom(i).type{1}(1:4);
    end
end

fid = fopen(filename_out, 'W');
tic
for t=1:length(nFrames)
    
    % % REMARK    GENERATED BY TRJCONV
    % % TITLE     MMT pull system t=   0.00000
    % % REMARK    THIS IS A SIMULATION BOX
    % % CRYST1   31.188   70.000   80.000  90.00  90.00  90.00 P 1           1
    % % MODEL        1
    
    fprintf(fid, '%s\n','REMARK    GENERATED BY MATLAB');
    fprintf(fid,'%-5s     %-15s%-3s%10.5f \n','TITLE',upper(filename_out),'t= ',t);
    fprintf(fid, '%s\n','REMARK    THIS IS A SIMULATION BOX');
    
    bt=t;
    if size(Box_dim,1)==1; bt=1; end
    
    if size(Box_dim,2)==3
        fprintf(fid, '%6s%9.3f%9.3f%9.3f%7.2f%7.2f%7.2f %11s%4i\n','CRYST1', Box_dim(bt,1:3), 90.00, 90.00, 90.00, 'P1', 1);
    elseif size(Box_dim,2)==9
        a=Box_dim(bt,1);
        b=Box_dim(bt,2);
        c=Box_dim(bt,3);
        xy=Box_dim(bt,6);
        xz=Box_dim(bt,8);
        yz=Box_dim(bt,9);
        lx = a;
        ly = (b^2-xy^2)^.5;
        lz = (c^2 - xz^2 - yz^2)^0.5;
        alfa=rad2deg(acos((ly*yz+xy*xz)/(b*c)));
        beta=rad2deg(acos(xz/c));
        gamma=rad2deg(acos(xy/b));
        fprintf(fid, '%6s%9.3f%9.3f%9.3f%7.2f%7.2f%7.2f %11s%4i\n','CRYST1', a, b, c, alfa, beta, gamma, 'P1', 1);
    else
        % Dummy Box_dim values
        fprintf(fid, '%s\n','CRYST1   10.000   10.000   10.000  90.00  90.00  90.00 P 1           1');
    end
    
    fprintf(fid,'%5s%9i\n','MODEL',t);
    
    % See http://deposit.rcsb.org/adit/docs/pdb_atom_format.html
    % COLUMNS        DATA  TYPE    FIELD        DEFINITION
    % -------------------------------------------------------------------------------------
    % 1 -  6         Record name   "ATOM  "
    % 7 - 11         Integer       Serial       Atom  serial number.
    % 13 - 16        Atom          Atom type    Atom name.   ->17 by MH
    % 17             Character     AltLoc       Alternate location indicator.
    % 18 - 20        Residue name  ResName      Residue name.
    % 22             Character     ChainID      Chain identifier.
    % 23 - 26        Integer       ResSeq       Residue sequence number.
    % 27             AChar         Code         Code for insertion of residues.
    % 31 - 38        Real(8.3)     X            Orthogonal coordinates for X in Angstroms.
    % 39 - 46        Real(8.3)     Y            Orthogonal coordinates for Y in Angstroms.
    % 47 - 54        Real(8.3)     Z            Orthogonal coordinates for Z in Angstroms.
    % 55 - 60        Real(6.2)     Occupancy    Occupancy.
    % 61 - 66        Real(6.2)     TempFactor   Temperature  factor.
    % 73 - 76        LString(4)    Segment identifier, left-justified. % Not used
    % 77 - 78        LString(2)    Element      Element symbol, right-justified.
    % 79 - 80        LString(2)    Charge       Charge on the atom.
    
    % Try also this if problems arise
    % fprintf(fid,'%-6s%5i %4s %3s %1s%4i    %8.3f%8.3f%8.3f%6.2f%6.2f          %2s\n',Atom_section{1:12});
    %
    for i = 1:nAtoms
        Atom_section(1:12) = ['HETATM', atom(i).index, atom(i).type, atom(i).resname, 'A',atom(i).molid, traj(t,1+3*(i-1)), traj(t,2+3*(i-1)), traj(t,3+3*(i-1)), 1, 1, atom(i).element];
        fprintf(fid,'%-6s%5i  %-4s%3s %1s%4i    %8.3f%8.3f%8.3f%6.2f%6.2f          %2s\n',Atom_section{1:12});
    end
    fprintf(fid, '%s\n','TER');
    fprintf(fid, '%s\n','ENDMDL');
    
    if mod(t,10)==0
        t
    end
    
end
toc
fclose(fid);

sprintf('.pdb file exported %d frames', nFrames(end))

