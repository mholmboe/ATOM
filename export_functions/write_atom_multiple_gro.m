%% write_atom_multiple_gro.m
% * This function writes a .gro trajectory
% * I think this function works...
%
%% Version
% 3.00
%
%% Contact
% Please report problems/bugs to michael.holmboe@umu.se
%
%% Examples
% # write_atom_multiple_gro(atom,traj,filename_out) % Basic input arguments
%
function write_atom_multiple_gro(atom,traj,filename_out)
%% 

nFrames=[1:size(atom(1).x,1)];
nAtoms=size(atom,2);
Atom_section=cell(nAtoms,10);

fid = fopen(strcat(filename_out,'.gro'), 'W');
tic
for frame=1:length(nFrames)
    
    Box_dim=traj.box(frame,:);
    
    Title='Generated by matlab        t=';
    TitleTot={Title traj.time(frame)};
    fprintf(fid,'%-40s%10.5f\n',TitleTot{:});
    fprintf(fid,'%5i\n',nAtoms);
    
    %sprintf('.gro file imported %d frames', nFrames(end))

    if isnan(atom(1).vx) || atom(1).vx == 0;
        %totstring=char(zeros(1,nAtoms*45));
        for i = 1:nAtoms
            Atom_section(1:7) = [atom(i).molid, atom(i).resname, atom(i).type, atom(i).index, atom(i).x(frame)/10, atom(i).y(frame)/10, atom(i).z(frame)/10];
            %string=sprintf('%5d%-5s%5s%5d%8.3f%8.3f%8.3f\n', Atom_section{1:7});
            %totstring=[totstring string];
            fprintf(fid, '%5d%-5s%5s%5d%8.3f%8.3f%8.3f\n', Atom_section{1:7});
        end
        %fprintf(fid,'%s%\n',totstring);
        %size(totstring);
    else
        % Untested
        for i = 1:nAtoms
            Atom_section(1:10) = [atom(i).molid, atom(i).resname, atom(i).type, atom(i).index, atom(i).x(frame)/10, atom(i).y(frame)/10, atom(i).z(frame)/10, atom(i).vx(frame)/10, atom(i).vy(frame)/10, atom(i).vz(frame)/10];
            fprintf(fid, '%5d%-5s%5s%5d%8.3f%8.3f%8.3f%8.4f%8.4f%8.4f\n', Atom_section{1:10});
        end
    end
    
    if size(Box_dim,2) == 3 || Box_dim(4) == 0 && Box_dim(5) == 0 && Box_dim(6) == 0
        fprintf(fid, '%10.5f%10.5f%10.5f\n',Box_dim(1:3)/10);
    else
        fprintf(fid, '%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f%10.5f\n',Box_dim/10);
    end
    
    if mod(frame,10)==0
        frame
    end
    
end
toc
fclose(fid);

sprintf('.gro file exported %d frames', nFrames(end))

