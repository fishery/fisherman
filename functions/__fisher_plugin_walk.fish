function __fisher_plugin_walk -a plugin path
    debug "walk %s" "$path"

    for file in $path/{functions/**,*,{conf.d,modules}/*}.{fish,load} $path/completions/*.fish
        set -l name (basename $file .fish)
        set -l base $name.fish

        if test "$name" = "getopts"
            continue # See #191
        end

        debug "file %s" $file

        switch $file
            case \*/{fish_user_,}key_bindings.fish
                printf "%s %s %s\n" --bind $file

            case \*/uninstall.fish
                printf "%s %s\n" --uninstall $file

            case \*/completions/\*.fish
                printf "%s %s %s\n" --source $file completions/$base

            case \*/{conf.d,modules}/\?\* \*/\*config.fish \*/{before.,}init.fish \*/$plugin.load
                switch "$base"
                    case \*$plugin\*
                    case \*
                        set base $plugin.$base
                end

                switch "$name"
                    case fish_postexec fish_preexec fish_command_not_found
                    case \*
                        set name
                end

                printf "%s %s %s %s\n" --source $file conf.d/$base $name

            case \*
                printf "%s %s %s %s\n" --source $file functions/$base $name
        end
    end

    for file in $path/{functions/,}*.{py,rb,php,pl,awk,sed}
        set -l prefix functions
        set -l target $prefix/(basename $file)

        debug "script %s" $target

        printf "%s %s %s\n" -- $file $target
    end

    for n in (seq 9)
        for file in $path/man/man$n/*.$n
            debug "man$n %s" $file

            printf "%s %s %s\n" --man $file man/man$n/(basename $file)
        end
    end
end
