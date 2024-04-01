function lfcd
    set tmp (mktemp)
    # `command` is needed in case `lfcd` is aliased to `lf`
    command lf -print-last-dir=$tmp $argv
    if test -f "$tmp"
        set dir (cat $tmp)
        rm -f $tmp
        if test -d "$dir"
            if test "$dir" != (pwd)
                cd $dir
            end
        end
    end
end
