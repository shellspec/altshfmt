Describe "altshfmt"
  Include ./altshfmt

  Describe "detect_syntax()"
    Context "when shell directive defined"
      Context "and not specified shebang"
        Data
          #|# shell: altsh=shellspec
          #|script
        End

        Specify "The default shell is auto"
          When call detect_syntax
          The line 1 should eq "auto altsh=shellspec"
          The lines of output should eq 3
        End
      End

      Context "and specified shebang and shell"
        Data
          #|#!/bin/sh
          #|# shell: bash altsh=shellspec
          #|script
        End

        Specify "The directive take precedence over shebang"
          When call detect_syntax
          The line 1 should eq "bash altsh=shellspec"
          The lines of output should eq 4
        End
      End

      Context "and specified shebang only"
        Data
          #|#!/usr/bin/bash aa
          #|# shell: altsh=shellspec
          #|script
        End

        Specify "Use shebang as the default shell"
          When call detect_syntax
          The line 1 should eq "bash altsh=shellspec"
          The lines of output should eq 4
        End

        Describe "using env"
          Data
            #|#!/usr/bin/env bash arg
            #|# shell: altsh=shellspec
            #|script
          End

          Specify "Use shebang as the default shell"
            When call detect_syntax
            The line 1 should eq "bash altsh=shellspec"
            The lines of output should eq 4
          End
        End
      End
    End

    Context "when shell directive not defined"
      Context "and not specified shebang"
        Data
          #|script
        End

        Specify "The default shell is auto"
          When call detect_syntax
          The line 1 should eq "auto"
          The lines of output should eq 2
        End
      End

      Context "and specified shebang"
        Data
          #|#!/usr/bin/env bash arg
          #|script
        End

        Specify "Use shebang as the default shell"
          When call detect_syntax
          The line 1 should eq "bash"
          The lines of output should eq 3
        End

        Data
          #|#!  /bin/bash   arg
          #|script
        End

        Specify "Allow spaces in shebang"
          When call detect_syntax
          The line 1 should eq "bash"
          The lines of output should eq 3
        End

        Data
          #|#!  /usr/bin/env   /bin/bash   arg
          #|script
        End

        Specify "Allow spaces in shebang with env command"
          When call detect_syntax
          The line 1 should eq "bash"
          The lines of output should eq 3
        End
      End

      Context "if shellspec DSL is found"
        Data
          #|#!/usr/bin/env bash arg
          #|script
          #|Describe
          #|End
        End

        Specify "The altsh is shellspec"
          When call detect_syntax
          The line 1 should eq "bash altsh=shellspec"
          The lines of output should eq 5
        End
      End
    End
  End

  Describe "optparse()"
    _optparse() {
      optparse "$@"
      eval "set -- $OPTARG"
      echo "$OPTIND:" "$@"
    }

    It "supports the -l flag"
      When call _optparse -l -x arg1 arg2
      The variable list should eq 1
      The output should eq "2: -x arg1 arg2"
    End

    It "supports the -w flag"
      When call _optparse -w -x arg1 arg2
      The variable write should eq 1
      The output should eq "2: -x arg1 arg2"
    End

    It "supports the -d flag"
      When call _optparse -d -x arg1 arg2
      The variable diff should eq 1
      The output should eq "2: -x arg1 arg2"
    End

    It "supports the -filename flag"
      When call _optparse -filename "path" -x arg1 arg2
      The variable filename should eq "path"
      The output should eq "4: -filename path -x arg1 arg2"
    End

    It "supports the -i flag"
      When call _optparse -i 2 -x arg1 arg2
      The output should eq "4: -i 2 -x arg1 arg2"
    End

    It "supports the -ln flag"
      When call _optparse -ln posix -x arg1 arg2
      The output should eq "4: -ln posix -x arg1 arg2"
    End

    It "supports the -f flag"
      When call _optparse -f -x arg1 arg2
      The variable find should eq 1
      The output should eq "3: -f -x arg1 arg2"
    End

    It "supports the -tojson flag"
      When call _optparse -tojson -x arg1 arg2
      The variable tojson should eq 1
      The output should eq "3: -tojson -x arg1 arg2"
    End

    It "supports unknown flags"
      When call _optparse -unknown -x arg1 arg2
      The status should be success
      The output should eq "3: -unknown -x arg1 arg2"
    End

    It "determines that there are paths"
      When call _optparse -p file -x arg1 arg2
      The status should be success
      The output should eq "2: -p file -x arg1 arg2"
    End

    It "can handle flags starting with --"
      When call _optparse --l -x arg1 arg2
      The variable list should eq 1
      The output should eq "2: -x arg1 arg2"
    End

    It "does not treat after PATH as a flag."
      When call _optparse -l -l arg1 arg2 -l
      The variable list should eq 1
      The output should eq "1: arg1 arg2 -l"
    End
  End
End
