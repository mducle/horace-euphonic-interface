function abspath = get_abspath(filename)
    % Get absolute path to a file in the test directory
    s = what('test');
    test_dir = s.path;
    abspath =  [test_dir filesep 'input' filesep filename];
end