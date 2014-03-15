function [data,sd,k,xb] = wanalyze(dirroot,d)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function [data, xb, sd, k] = wanalyze(dirroot,d)
% 
% arguments:
%  dirroot : root directory for the data files to read in
%  d       : the dir() output containing the sequence of files to 
%            read
%
% returns:
%  data    : given m files to read in with n entries per file, an 
%            mxn matrix containing one data set per row.  data
%            rows are ordered lexicographical by filename, NOT
%            numerically.  Beware!
%  xb      : mean of scaled noise of the data
%  sd      : standard deviation of scaled noise of the data 
%  k       : kurtosis value of scaled noise of the data
%
% example usage (assume data is ftq_X_counts.dat in the directory 
%                "/home/matt/data").
%
%   d = dir('/home/matt/data/*counts*.dat');
%   [data,xb,sd,k] = analyze('/home/matt/data',d);
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

num_files = length(d);

% iterate through files.  NOTE: ordering is lexicographic, NOT
% numerical!
for i=1:num_files
  data(i,:) = load(strcat([dirroot '/' d(i).name]));
end

% count number of samples.  all sample sequences assumed to be
% the same length.
npts = length(data(1,:));

% find maximum value that occurs in all data sets
maxval = max(data(:));
minval = min(data(:));

% Remove the work (minval time) to expose the noise and scale the noise
% as a percentage of the work.
for i=1:num_files
  data(i,:) = (data(i,:).-minval)./minval;
end

for i=1:num_files
  scaled_maxval = max(data(:));
  scaled_minval = min(data(:));
  xb(i) = mean(data(i,:));
  sd(i) = std(data(i,:));
  knum(i) = sum((data(i,:)-xb(i)).^4);
  kden(i) = npts*sd(i)^4;
  k(i) = kurtosis(data(i,:));
end
  printf('Min=%d\n', minval);
  printf('Max=%d\n', maxval);
  printf('ScaledMin=%0.4f\n', scaled_minval);
  printf('ScaledMax=%0.4f\n', scaled_maxval);
  printf('Mean=%.4f\n', xb);
  printf('Knum=%.4e\n', knum);
  printf('StdDev=%.4f\n', sd);
  printf('Kden=%.4e\n', kden);
  printf('kurtosis=%.4f\n', k);
