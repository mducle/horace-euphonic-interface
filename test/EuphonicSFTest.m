classdef EuphonicSFTest < matlab.unittest.TestCase

    properties
        qpts
        pars
        scattering_lengths
        opts
    end

    methods (TestClassSetup)
        function setQpts(testCase)
            qpts = [0.0, 0.0, 0.0;
                    0.1, 0.2, 0.3;
                    0.4, 0.5, 0.0;
                    0.6, 0.0, 0.7;
                    0.0, 0.8, 0.9];
            scattering_lengths = struct('La', 8.24, 'Zr', 7.16, 'O', 5.803, ...
                                        'Si', 4.1491, 'Na', 3.63, 'Cl', 9.577);
            s = what('test')
            model_args = {[s.path filesep 'quartz.castep_bin']};
            scale = 1.0;
            temp = 5;

            testCase.qpts = qpts
            testCase.pars = [temp scale];
            testCase.scattering_lengths = scattering_lengths;
            testCase.opts = {'model_args', model_args};
        end
    end

    methods(Test)
        function testThing(testCase)
            qpts = testCase.qpts;
            [w, sf] = euphonic_sf(qpts(:, 1), qpts(:, 2), qpts(:, 3), ...
                                  testCase.pars, ...
                                  testCase.scattering_lengths, testCase.opts);
        end
    end
end