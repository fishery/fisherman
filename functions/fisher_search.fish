function fisher_search -d "Search plugin index"
    set -l fields
    set -l query
    set -l index
    set -l join "||"
    set -l format
    set -l option
    set -l stdout /dev/stdout

    getopts $argv | while read -l 1 2 3
        switch "$1"
            case _
                switch "$2"
                    case \*/\*
                        set -l url (__fisher_plugin_validate $2)

                        if test ! -z "$url"
                            set 2 $url
                        end

                        set query $query "url==\"$2\"" $join

                    case \*
                        set query $query "name==\"$2\"" $join
                end

            case name url info author
                if test -z "$2"
                    set fields $fields $1 ,
                else
                    switch "$2"
                        case ~\*
                            set query $query "$1$3$2" $join

                        case \*
                            if test -z "$3"
                                set 3 =
                            end
                            set query $query "$1$3=\"$2\"" $join
                    end
                end

            case tag{,s}
                if test -z "$2"
                    set fields $fields "tags(0)" ,
                else
                    set query $query "$3 tags(\"$2\")" $join
                end

            case long
                set format long

            case full
                set format full

            case a and
                set join "&&"

            case o or
                set join "||"

            case C no-color
                set option no-color

            case query
                set query $query $2

            case index
                set index $2

            case q quiet
                set stdout /dev/null

            case h
                printf "Usage: fisher search [<plugins>] [--long] [--full] [--no-color]\n"
                printf "                     [--quiet] [--help]\n\n"
                printf "       --long       Display results in long format\n"
                printf "       --full       Display results in full format\n"
                printf "    -C --no-color   Turn off color display\n"
                printf "    -q --quiet      Enable quiet mode\n"
                printf "    -h --help       Show usage help\n"
                return

            case \*
                printf "fisher: '%s' is not a valid option.\n" $1 > /dev/stderr
                fisher_search -h > /dev/stderr
                return 1
        end
    end

    if test -z "$index"
        set index $fisher_cache/.index

        set fisher_last_update (math (date +%s) - "0$fisher_last_update")

        if not set -q fisher_update_interval
            set -g fisher_update_interval 50
        end

        if test $fisher_last_update -gt $fisher_update_interval -o ! -f $index
            debug "Update index start"

            if spin "__fisher_index_update" --error=/dev/null
                debug "Update index success"

                __fisher_complete_reset
            else
                debug "Update index fail"
            end
        end

        set -U fisher_last_update (date +%s)
    end

    set -e fields[-1]
    set -e query[-1]

    set -l options -v OFS=';' -v compact=1

    if test -z "$fields[1]"
        set options -v OFS='\n'

        if test -z "$format"
            if test -z "$fisher_search_format"
                set format default
            else
                set format "$fisher_search_format"
            end
        end

        set -l name_color (set_color $fish_color_command)
        set -l url_color (set_color $fish_color_cwd -u)
        set -l tag_color (set_color $fish_color_cwd)
        set -l weak_color (set_color white)
        set -l author_color (set_color -u)
        set -l normal (set_color $fish_color_normal)

        if contains -- no-color $option
            set name_color
            set url_color
            set tag_color
            set weak_color
            set author_color
            set normal
        end

        set legend
        set local (fisher_list | awk '

            !/^@/ {
                if (append) {
                    printf("|")
                }

                printf("%s", substr($0, 3))

                append++
            }
        '
        )

        if test ! -z "$local"
            set legend "  "
        end

        set fields '
            legend="*"

            if ($1 == "'"$fisher_prompt"'") {
                legend = ">"
            }

            if ("'"$local"'" && $1~/'"$local"'/) {
        '

        switch "$format"
            case default
                set fields $fields '
                    printf("%s '"$weak_color"'%-18s'"$normal"' %s\n", legend, $1, $3)
                } else {
                    printf("'"$legend$name_color"'%-18s'"$normal"' %s\n", $1, $3)
                }
                '
                set options $options -v compact=1

            case long
                set fields $fields '
                    printf("%-40s %s '"$weak_color"'%-18s'"$normal"' %s\n", humanize_url($2), legend, $1, $3)
                } else {
                    printf("'"$tag_color"'%-40s'"$normal"' '"$legend$name_color"'%-18s'"$normal"' %s\n", humanize_url($2), $1, $3)
                }
                '
                set options $options -v compact=1

            case full
                set fields $fields '
                    printf("'"$weak_color"'%s %s by %s\n%s'"$normal"'\n%s\n", legend, $1, $5, $3, humanize_url($2))
                } else {
                    printf("'"$name_color"'%s'"$normal"' by '"$author_color"'%s'"$normal"'\n%s\n'"$url_color"'%s'"$normal"'\n", $1, $5, $3, humanize_url($2))
                }
                '
        end
    else
        if test "$fields" = author
            set options $options -v unique=1
        end

        set fields print $fields
    end

    awk -v FS='\n' -v RS='' $options "

    function humanize_url(url) {
        gsub(\"(https?://)?(www.)?|/\$\", \"\", url)
        return url
    }

    function tags(tag, _list) {
        if (!tag) {
            for (i in tag_list) {
                if (!seen[tag_list[i]]++) {
                    _list = tag_list[i] \"\n\" _list
                }
            }
            return substr(_list, 1, length(_list) - 1)
        }
        for (i in tag_list) {
            if (tag == tag_list[i]) {
                return 1
            }
        }
        return 0
    }

    {
        delete tag_list

        if (\$4) {
            split(\$4, tag_list, \" \")
        }

        name = \$1
        url = \$2
        info = \$3
        author = \$5
    }

    $query {
        if (has_records && !compact) {
            print \"\"
        }

        if (!shit[\$5] || !unique) {
            shit[\$5] = 1
            $fields
        }

        has_records = 1
    }

    END { exit !has_records }

    " $index > $stdout ^ /dev/null
end
