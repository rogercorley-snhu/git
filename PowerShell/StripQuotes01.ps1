ls <DIRECTORY_PATH> -Fi *.<FILE_TYPE> |
    ? {$_.basename -like '<FILE_NAME_PARTIAL>?'} |
        ipcsv |
            sort <COLUMN_ONE>, <COLUMN_TWO_IF_NEEDED> |
                convertto-csv -NoTypeInformation |
                    % { $_ -replace '"', ""} |
                        out-file <FULL_FILE_NAME_PATH> -fo -en ascii