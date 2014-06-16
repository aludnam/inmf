function coord_all = localize(resDir,psf,run_range,patch_name)
% Localize in x,y,z from using given 3D psf. 
%
% coord_all = localize(resDir,psf)
% coord_all[:,1:3] - x,y,z coordinates
% coord_all[:,4] - mean brightness
% coord_all[:,5] - correlation value
% coord_all[:,6] - index of evaluation
%
% Caution: Needs function dftregistration or findshift!

addpath ~/Documents/MATLAB/efficient_subpixel_registration/

if ~exist('run_range','var'); run_range=[]; end
if ~exist('patch_name','var'); patch_name = 'P*'; end

d=dir([resDir '/' patch_name]);
coord_all = []; 

for ii=1:length(d) % patches
    fprintf('Processing patch %s', [resDir '/' d(ii).name])
    sd = dir([resDir '/' d(ii).name '/results_run*']);
    for jj=1:length(sd) % runs
        q = strread(sd(jj).name,'%s','delimiter','run');            
        run_ind = str2double(q{end});
        if or(any(run_ind == run_range), isempty(run_range))
            %try
                load ([resDir '/' d(ii).name '/' sd(jj).name '/w'])
                load ([resDir '/' d(ii).name '/' sd(jj).name '/h'])
                load ([resDir '/' d(ii).name '/' sd(jj).name '/peval'])
                fprintf '-'
                fprintf('%g',peval.ddiv(end))
                rw = reshape(w,peval.nx,peval.ny,peval.K);
                brightness = mean(h(1:end-1,:),2);      % mean brightness of the source
                xcmax = zeros(size(psf,3),size(rw,3));
                for kk=1:size(psf,3)
                    for ll=1:size(rw,3)
                        xcmax(kk,ll)=xcorrMax(psf(:,:,kk),rw(:,:,ll));
                    end
                end
                [m,z_ind]=max(xcmax(:,1:end-1),[],1);   % finds z-localisation from the maximum of the correlation
                coord = zeros(length(m),6);             % first three entries are the x,y,z coordinates, 4th entry is the mean brightness, 5th entry is the correlation value, 6th entry is the run index                
                srw = size(rw);                                
                s_real = (size(psf)-size(rw))/2+1;
                s = ceil(s_real);  % excessive border of the psf
                offset = s - s_real; % in case the peval.nx or peval.ny are not even, always non-negative (s>=s_real)
                psf_crop = psf(s(1):s(1)+srw(1)-1,s(2):s(2)+srw(2)-1,:);
                for mm = 1:length(m)
                    A = rw(:,:,mm);
                    B = psf_crop(:,:,z_ind(mm));
                    %ABshift = findshift(B,A)'
                    [output Greg] = dftregistration(fft2(B),fft2(A),10);        % registration with precision 0.1 pixels
                    ABshift = output(3:4);
                    coord(mm,1:2) = size(B)/2-ABshift+peval.cornerNW-1+offset(1:2);     % x,y coordinates                
                    coord(mm,3) = z_ind(mm);                                            % z coordiante 
                    coord(mm,4) = brightness(mm);                                       % brightness
                    coord(mm,5) = m(mm);                                                % correlation value                
                    coord(mm,6) = run_ind;                                              % index of the evaluation
                end
                coord_all = [coord_all; coord];
            %end
        end
    end    
    fprintf('\n')
end
end

function [xcmax, xcw] = xcorrMax(a,b)
    xc=xcorr2(a,b);
    xaa=xcorr2(a,a);
    xbb=xcorr2(b,b);
    xcw = xc(:)/sqrt(max(xaa(:))*max(xbb(:)));
    xcmax=max(xcw);
end